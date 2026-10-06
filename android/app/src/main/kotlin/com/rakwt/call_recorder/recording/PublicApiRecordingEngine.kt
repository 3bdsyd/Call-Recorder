package com.rakwt.call_recorder.recording

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import androidx.core.content.ContextCompat
import com.rakwt.call_recorder.audio.AudioValidator
import com.rakwt.call_recorder.audio.WavFile
import com.rakwt.call_recorder.bridge.NativeLog
import java.io.File
import java.io.RandomAccessFile
import kotlin.concurrent.thread

/**
 * The honest, unprivileged baseline: an in-app [AudioRecord] from a MIC-family source, written to
 * 16-bit PCM WAV.
 *
 * On Android 10+ this path cannot hold CAPTURE_AUDIO_OUTPUT, so during a cellular call it captures
 * the local microphone — i.e. (at best) ONE side, plus whatever the earpiece/speaker leaks. That is
 * not a bug to hide; it is precisely the result the compatibility test must surface so the user
 * learns what their device actually does without elevated privilege.
 */
class PublicApiRecordingEngine(private val context: Context) : RecordingEngine {

    override val strategy = RecordingStrategy.PUBLIC_API

    private val sampleRate = 16_000
    private val channelConfig = AudioFormat.CHANNEL_IN_MONO
    private val channels = 1
    private val bitsPerSample = 16

    @Volatile private var recorder: AudioRecord? = null
    @Volatile private var recordThread: Thread? = null
    @Volatile private var active = false
    @Volatile private var outputFile: File? = null
    @Volatile private var usedSource: String = "unknown"
    @Volatile private var lastError: String? = null

    override fun isAvailable(): Boolean =
        ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) ==
            PackageManager.PERMISSION_GRANTED

    override fun startRecording(request: RecordingRequest): Boolean {
        if (active) return false
        lastError = null
        if (!isAvailable()) {
            lastError = "RECORD_AUDIO not granted"
            NativeLog.e("RECORDING_FAILED", mapOf("strategy" to strategy.wire, "reason" to lastError))
            return false
        }
        val file = File(request.outputFile)
        file.parentFile?.mkdirs()
        outputFile = file

        val minBuf = AudioRecord.getMinBufferSize(sampleRate, channelConfig, AudioFormat.ENCODING_PCM_16BIT)
        if (minBuf <= 0) {
            lastError = "getMinBufferSize=$minBuf"
            return false
        }
        val bufferSize = minBuf * 4

        val rec = tryOpen(bufferSize)
        if (rec == null) {
            lastError = lastError ?: "AudioRecord could not be opened"
            NativeLog.e("RECORDING_FAILED", mapOf("strategy" to strategy.wire, "reason" to lastError))
            return false
        }
        recorder = rec

        val raf = RandomAccessFile(file, "rw")
        WavFile.writeHeader(raf, channels, sampleRate, bitsPerSample, 0)

        active = true
        try {
            rec.startRecording()
        } catch (t: Throwable) {
            lastError = "startRecording threw: ${t.message}"
            active = false
            runCatching { raf.close() }
            return false
        }
        NativeLog.i("RECORDING_STARTED", mapOf("strategy" to strategy.wire, "source" to usedSource, "sampleRate" to sampleRate))

        recordThread = thread(name = "public-rec") {
            val buf = ByteArray(bufferSize)
            try {
                while (active) {
                    val n = rec.read(buf, 0, buf.size)
                    if (n > 0) {
                        raf.write(buf, 0, n)
                    } else if (n < 0) {
                        lastError = "AudioRecord.read error $n"
                        NativeLog.e("RECORDING_READ_ERROR", mapOf("code" to n))
                        break
                    }
                }
            } catch (t: Throwable) {
                lastError = "read/write failed: ${t.message}"
            } finally {
                runCatching { raf.close() }
                WavFile.finalizeHeader(file, channels, sampleRate, bitsPerSample)
            }
        }
        return true
    }

    /**
     * Try a small ladder of MIC-family sources. VOICE_RECOGNITION disables AGC/NS on many devices,
     * which tends to leak more of the earpiece side than the heavily-processed VOICE_COMMUNICATION.
     */
    private fun tryOpen(bufferSize: Int): AudioRecord? {
        val ladder = listOf(
            MediaRecorder.AudioSource.VOICE_RECOGNITION to "VOICE_RECOGNITION",
            MediaRecorder.AudioSource.VOICE_COMMUNICATION to "VOICE_COMMUNICATION",
            MediaRecorder.AudioSource.MIC to "MIC",
        )
        for ((src, name) in ladder) {
            try {
                @Suppress("MissingPermission")
                val rec = AudioRecord(src, sampleRate, channelConfig, AudioFormat.ENCODING_PCM_16BIT, bufferSize)
                if (rec.state == AudioRecord.STATE_INITIALIZED) {
                    usedSource = name
                    return rec
                }
                rec.release()
            } catch (t: Throwable) {
                lastError = "open $name failed: ${t.message}"
            }
        }
        return null
    }

    override fun stopRecording(): RecordingDiagnostics {
        active = false
        runCatching { recordThread?.join(2500) }
        recordThread = null
        val rec = recorder
        recorder = null
        if (rec != null) {
            runCatching { if (rec.recordingState == AudioRecord.RECORDSTATE_RECORDING) rec.stop() }
            runCatching { rec.release() }
        }
        NativeLog.i("RECORDING_STOPPED", mapOf("strategy" to strategy.wire))
        val diag = AudioValidator.validate(outputFile?.path, strategy, usedSource)
        NativeLog.i("FILE_VALIDATED", diag.toMap())
        return if (lastError != null && diag.status == RecordingStatus.INVALID_FILE)
            diag.copy(errorReason = lastError) else diag
    }

    override fun isRecording(): Boolean = active
    override fun currentOutputFile(): String? = outputFile?.path

    override fun validateRecording(): RecordingDiagnostics =
        AudioValidator.validate(outputFile?.path, strategy, usedSource)

    override fun getRecordingDiagnostics(): Map<String, Any?> = mapOf(
        "strategy" to strategy.wire,
        "active" to active,
        "source" to usedSource,
        "sampleRate" to sampleRate,
        "channels" to channels,
        "outputFile" to outputFile?.path,
        "lastError" to lastError,
    )

    override fun release() {
        active = false
        runCatching { recorder?.release() }
        recorder = null
    }
}
