package com.rakwt.call_recorder.recording

import android.content.ComponentName
import android.content.Context
import android.content.ServiceConnection
import android.content.pm.PackageManager
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import android.os.ParcelFileDescriptor
import com.rakwt.call_recorder.audio.AudioValidator
import com.rakwt.call_recorder.audio.WavFile
import com.rakwt.call_recorder.bridge.NativeLog
import com.rakwt.call_recorder.shizuku.IRecorderService
import com.rakwt.call_recorder.shizuku.RecorderUserService
import rikka.shizuku.Shizuku
import java.io.File
import java.io.FileInputStream
import java.io.RandomAccessFile
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import kotlin.concurrent.thread

/**
 * Both-sides capture via a Shizuku UserService running as the shell user. The privileged process
 * opens the AudioRecord; this engine reads the PCM it streams back and writes a stereo WAV so the
 * [AudioValidator] can decide whether both channels actually carry audio.
 *
 * Nothing here assumes success: if Shizuku is absent/unauthorised, or the HAL returns silence, the
 * diagnostics say so plainly. Requires API 31+ for the UserService audio path we rely on.
 */
class ShizukuRecordingEngine(private val context: Context) : RecordingEngine {

    override val strategy = RecordingStrategy.SHIZUKU_VOICE_CALL

    private val sampleRate = 48_000
    private val requestedChannels = 2
    private val bitsPerSample = 16

    @Volatile private var service: IRecorderService? = null
    @Volatile private var connection: ServiceConnection? = null
    @Volatile private var active = false
    @Volatile private var outputFile: File? = null
    @Volatile private var readThread: Thread? = null
    @Volatile private var writtenChannels = requestedChannels
    @Volatile private var lastError: String? = null

    override fun isAvailable(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) return false
        return try {
            Shizuku.pingBinder() &&
                Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED
        } catch (t: Throwable) {
            false
        }
    }

    /** True if Shizuku is installed/running but we have not yet been granted permission. */
    fun needsPermission(): Boolean = try {
        Shizuku.pingBinder() && Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED
    } catch (t: Throwable) {
        false
    }

    private fun bind(): IRecorderService? {
        service?.let { return it }
        val latch = CountDownLatch(1)
        val args = Shizuku.UserServiceArgs(
            ComponentName(context.packageName, RecorderUserService::class.java.name)
        ).daemon(false).processNameSuffix("recorder").version(1)

        val conn = object : ServiceConnection {
            override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
                service = if (binder != null && binder.pingBinder()) {
                    IRecorderService.Stub.asInterface(binder)
                } else null
                latch.countDown()
            }
            override fun onServiceDisconnected(name: ComponentName?) {
                service = null
            }
        }
        connection = conn
        return try {
            Shizuku.bindUserService(args, conn)
            if (!latch.await(8, TimeUnit.SECONDS)) {
                lastError = "Shizuku UserService bind timed out"
                null
            } else service
        } catch (t: Throwable) {
            lastError = "bindUserService failed: ${t.message}"
            null
        }
    }

    override fun startRecording(request: RecordingRequest): Boolean {
        if (active) return false
        lastError = null
        if (!isAvailable()) {
            lastError = "Shizuku not available or not authorised"
            NativeLog.e("RECORDING_FAILED", mapOf("strategy" to strategy.wire, "reason" to lastError))
            return false
        }
        val svc = bind()
        if (svc == null) {
            lastError = lastError ?: "could not bind Shizuku UserService"
            NativeLog.e("RECORDING_FAILED", mapOf("strategy" to strategy.wire, "reason" to lastError))
            return false
        }

        val file = File(request.outputFile)
        file.parentFile?.mkdirs()
        outputFile = file

        val channels = if (request.wantBothSides) requestedChannels else 1
        val pfd: ParcelFileDescriptor? = try {
            svc.startCapture(MediaRecorder.AudioSource.VOICE_CALL, sampleRate, channels)
        } catch (t: Throwable) {
            lastError = "startCapture threw: ${t.message}"
            null
        }
        val recState = runCatching { svc.lastRecordState() }.getOrDefault(0)
        if (pfd == null) {
            lastError = runCatching { svc.lastError() }.getOrNull() ?: lastError ?: "startCapture returned null (state=$recState)"
            NativeLog.e("RECORDING_FAILED", mapOf("strategy" to strategy.wire, "reason" to lastError, "recordState" to recState))
            return false
        }
        writtenChannels = channels

        val raf = RandomAccessFile(file, "rw")
        WavFile.writeHeader(raf, channels, sampleRate, bitsPerSample, 0)
        active = true
        NativeLog.i("RECORDING_STARTED", mapOf("strategy" to strategy.wire, "source" to "VOICE_CALL", "channels" to channels, "recordState" to recState))

        readThread = thread(name = "shizuku-read") {
            val input = FileInputStream(pfd.fileDescriptor)
            val buf = ByteArray(32 * 1024)
            try {
                while (active) {
                    val n = input.read(buf)
                    if (n > 0) raf.write(buf, 0, n)
                    else if (n < 0) break   // EOF: far side closed the pipe
                }
            } catch (t: Throwable) {
                lastError = "read failed: ${t.message}"
            } finally {
                runCatching { input.close() }
                runCatching { pfd.close() }
                runCatching { raf.close() }
                WavFile.finalizeHeader(file, channels, sampleRate, bitsPerSample)
            }
        }
        return true
    }

    override fun stopRecording(): RecordingDiagnostics {
        active = false
        runCatching { service?.stopCapture() }
        runCatching { readThread?.join(3000) }
        readThread = null
        val svcErr = runCatching { service?.lastError() }.getOrNull()
        if (svcErr != null) lastError = svcErr
        NativeLog.i("RECORDING_STOPPED", mapOf("strategy" to strategy.wire))

        val diag = AudioValidator.validate(outputFile?.path, resolvedStrategy(), "VOICE_CALL")
            .let { if (lastError != null) it.copy(errorReason = it.errorReason ?: lastError) else it }
        NativeLog.i("FILE_VALIDATED", diag.toMap())
        return diag
    }

    private fun resolvedStrategy() =
        if (writtenChannels >= 2) RecordingStrategy.SHIZUKU_DUAL else RecordingStrategy.SHIZUKU_VOICE_CALL

    override fun isRecording(): Boolean = active
    override fun currentOutputFile(): String? = outputFile?.path

    override fun validateRecording(): RecordingDiagnostics =
        AudioValidator.validate(outputFile?.path, resolvedStrategy(), "VOICE_CALL")

    override fun getRecordingDiagnostics(): Map<String, Any?> = mapOf(
        "strategy" to strategy.wire,
        "active" to active,
        "available" to isAvailable(),
        "needsPermission" to needsPermission(),
        "channels" to writtenChannels,
        "sampleRate" to sampleRate,
        "outputFile" to outputFile?.path,
        "lastError" to lastError,
        "shizukuRecordState" to runCatching { service?.lastRecordState() }.getOrNull(),
    )

    override fun release() {
        active = false
        runCatching { service?.stopCapture() }
        connection?.let { conn ->
            runCatching {
                val args = Shizuku.UserServiceArgs(
                    ComponentName(context.packageName, RecorderUserService::class.java.name)
                ).daemon(false).processNameSuffix("recorder").version(1)
                Shizuku.unbindUserService(args, conn, true)
            }
        }
        connection = null
        service = null
    }
}
