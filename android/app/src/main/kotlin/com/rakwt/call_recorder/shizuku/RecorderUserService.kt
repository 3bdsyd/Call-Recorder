package com.rakwt.call_recorder.shizuku

import android.content.Context
import android.media.AudioFormat
import android.media.AudioRecord
import android.os.Handler
import android.os.HandlerThread
import android.os.ParcelFileDescriptor
import android.util.Log
import java.io.FileOutputStream
import java.util.concurrent.CountDownLatch
import java.util.concurrent.atomic.AtomicReference
import kotlin.concurrent.thread
import kotlin.system.exitProcess

/**
 * Runs inside the Shizuku-spawned process as the shell user (uid 2000). Because shell holds
 * CAPTURE_AUDIO_OUTPUT at signature level, an AudioRecord opened here with VOICE_CALL can succeed
 * where an ordinary app's cannot.
 *
 * Design notes learned from the open-source ecosystem (re-implemented independently):
 *  - Construct AudioRecord on a thread that has a prepared Looper; on a bare Binder thread the
 *    AppOps thread-locals are blank and the record comes back STATE_UNINITIALIZED.
 *  - Use the legacy constructor here: in a bare shell process with no bound ActivityThread the
 *    attribution resolves to (uid 2000, no package), which is the identity AudioFlinger accepts
 *    for shell. Whether the HAL then delivers audio (and both sides) is device-dependent — we do
 *    not assume it; we stream whatever we get and let the app measure it.
 *  - Stream raw PCM back over a pipe; the app writes/validates the WAV so file ownership stays with
 *    the app.
 *
 * This whole technique is known to be fragile across Android releases. Failure is reported, not
 * hidden: [lastRecordState] and [lastError] tell the app exactly what happened.
 */
class RecorderUserService() : IRecorderService.Stub() {

    @Suppress("unused")
    constructor(context: Context) : this()

    @Volatile private var record: AudioRecord? = null
    @Volatile private var pumpThread: Thread? = null
    @Volatile private var capturing = false
    @Volatile private var recordState = AudioRecord.STATE_UNINITIALIZED
    @Volatile private var errorMessage: String? = null
    private var writeEnd: ParcelFileDescriptor? = null

    override fun startCapture(audioSource: Int, sampleRate: Int, channelCount: Int): ParcelFileDescriptor? {
        if (capturing) return null
        errorMessage = null
        recordState = AudioRecord.STATE_UNINITIALIZED
        try {
            val channelMask =
                if (channelCount >= 2) AudioFormat.CHANNEL_IN_STEREO else AudioFormat.CHANNEL_IN_MONO
            val minBuf = AudioRecord.getMinBufferSize(sampleRate, channelMask, AudioFormat.ENCODING_PCM_16BIT)
            if (minBuf <= 0) {
                errorMessage = "getMinBufferSize=$minBuf"
                return null
            }
            val bufferSize = minBuf * 4
            val rec = constructOnLooper(audioSource, sampleRate, channelMask, bufferSize)
            if (rec == null) {
                errorMessage = errorMessage ?: "AudioRecord construction returned null"
                return null
            }
            recordState = rec.state
            if (rec.state != AudioRecord.STATE_INITIALIZED) {
                errorMessage = "AudioRecord state=${rec.state} (not INITIALIZED) source=$audioSource"
                runCatching { rec.release() }
                return null
            }
            record = rec

            val pipe = ParcelFileDescriptor.createReliablePipe()
            val readEnd = pipe[0]
            writeEnd = pipe[1]

            rec.startRecording()
            capturing = true

            pumpThread = thread(name = "shizuku-pump") {
                val out = ParcelFileDescriptor.AutoCloseOutputStream(writeEnd) as FileOutputStream
                val buf = ByteArray(bufferSize)
                try {
                    while (capturing) {
                        val n = rec.read(buf, 0, buf.size)
                        if (n > 0) out.write(buf, 0, n)
                        else if (n < 0) { errorMessage = "read error $n"; break }
                    }
                } catch (t: Throwable) {
                    errorMessage = "pump failed: ${t.message}"
                } finally {
                    runCatching { out.flush() }
                    runCatching { out.close() }
                }
            }
            return readEnd
        } catch (t: Throwable) {
            Log.e("CallRec", "startCapture failed", t)
            errorMessage = "startCapture threw: ${t.message}"
            capturing = false
            return null
        }
    }

    private fun constructOnLooper(source: Int, sampleRate: Int, channelMask: Int, bufferSize: Int): AudioRecord? {
        val handlerThread = HandlerThread("rec-ctor").apply { start() }
        val handler = Handler(handlerThread.looper)
        val ref = AtomicReference<AudioRecord?>(null)
        val latch = CountDownLatch(1)
        handler.post {
            try {
                @Suppress("MissingPermission")
                ref.set(AudioRecord(source, sampleRate, channelMask, AudioFormat.ENCODING_PCM_16BIT, bufferSize))
            } catch (t: Throwable) {
                errorMessage = "ctor threw: ${t.javaClass.simpleName}: ${t.message}"
            } finally {
                latch.countDown()
            }
        }
        if (!latch.await(2, java.util.concurrent.TimeUnit.SECONDS)) {
            errorMessage = "AudioRecord ctor timed out"
        }
        handlerThread.quitSafely()
        return ref.get()
    }

    override fun stopCapture() {
        capturing = false
        runCatching { pumpThread?.join(2000) }
        pumpThread = null
        record?.let { rec ->
            runCatching { if (rec.recordingState == AudioRecord.RECORDSTATE_RECORDING) rec.stop() }
            runCatching { rec.release() }
        }
        record = null
        runCatching { writeEnd?.close() }
        writeEnd = null
    }

    override fun isCapturing(): Boolean = capturing
    override fun lastRecordState(): Int = recordState
    override fun lastError(): String? = errorMessage

    override fun destroy() {
        runCatching { stopCapture() }
        exitProcess(0)
    }
}
