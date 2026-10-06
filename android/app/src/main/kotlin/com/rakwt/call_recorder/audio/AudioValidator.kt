package com.rakwt.call_recorder.audio

import android.media.MediaMetadataRetriever
import com.rakwt.call_recorder.recording.RecordingDiagnostics
import com.rakwt.call_recorder.recording.RecordingStatus
import com.rakwt.call_recorder.recording.RecordingStrategy
import java.io.BufferedInputStream
import java.io.File
import java.io.FileInputStream
import kotlin.math.sqrt

/**
 * Validates a finished (or in-progress) recording and decides the honest status.
 *
 * The key question the POC must answer is "both sides, one side, or silence?". For PCM WAV we can
 * answer it directly by measuring energy per channel; for any other container we can still report
 * duration/decodability via [MediaMetadataRetriever] but cannot prove per-channel presence.
 */
object AudioValidator {

    // Normalised RMS thresholds (0..1 over 16-bit full scale).
    private const val SILENCE_RMS = 0.0015    // ~ -56 dBFS: below this a channel is "silent"
    private const val AUDIBLE_RMS = 0.0040    // ~ -48 dBFS: above this a channel clearly carries audio
    private const val MIN_VALID_DURATION_MS = 700L
    private const val MIN_VALID_BYTES = 2048L
    private const val WINDOW_MS = 200

    fun validate(path: String?, strategy: RecordingStrategy, audioSource: String?): RecordingDiagnostics {
        if (path == null) {
            return RecordingDiagnostics.failed(strategy, "no output path")
        }
        val file = File(path)
        if (!file.exists()) {
            return RecordingDiagnostics.failed(strategy, "file does not exist", path)
        }
        val size = file.length()
        if (size < MIN_VALID_BYTES) {
            return invalid(strategy, path, size, "file too small ($size bytes)")
        }

        return if (path.endsWith(".wav", ignoreCase = true)) {
            validateWav(file, strategy, audioSource)
        } else {
            validateOpaque(file, strategy, audioSource)
        }
    }

    private fun validateWav(file: File, strategy: RecordingStrategy, audioSource: String?): RecordingDiagnostics {
        val header = WavFile.readHeader(file)
            ?: return invalid(strategy, file.path, file.length(), "unreadable WAV header")
        if (header.bitsPerSample != 16) {
            return validateOpaque(file, strategy, audioSource) // fall back; we only PCM-analyse 16-bit
        }
        val notes = mutableListOf<String>()
        val channels = header.channels
        val bytesPerFrame = header.bytesPerFrame.coerceAtLeast(1)
        val framesPerWindow = (header.sampleRate * WINDOW_MS / 1000).coerceAtLeast(1)

        // Per-channel accumulated energy + per-window silence counting.
        val sumSq = DoubleArray(channels)
        var frameCount = 0L
        var windows = 0L
        var silentWindows = 0L
        var winSumSq = DoubleArray(channels)
        var winFrames = 0

        BufferedInputStream(FileInputStream(file)).use { input ->
            input.skip(WavFile.HEADER_SIZE.toLong())
            val buf = ByteArray(bytesPerFrame * framesPerWindow)
            while (true) {
                val read = input.read(buf)
                if (read <= 0) break
                var i = 0
                while (i + bytesPerFrame <= read) {
                    for (ch in 0 until channels) {
                        val lo = buf[i + ch * 2].toInt() and 0xFF
                        val hi = buf[i + ch * 2 + 1].toInt()
                        val sample = (hi shl 8) or lo       // signed 16-bit LE
                        val norm = sample / 32768.0
                        sumSq[ch] += norm * norm
                        winSumSq[ch] += norm * norm
                    }
                    i += bytesPerFrame
                    frameCount++
                    winFrames++
                    if (winFrames >= framesPerWindow) {
                        windows++
                        val maxRms = (0 until channels).maxOf { sqrt(winSumSq[it] / winFrames) }
                        if (maxRms < SILENCE_RMS) silentWindows++
                        winSumSq = DoubleArray(channels)
                        winFrames = 0
                    }
                }
            }
        }
        if (winFrames > 0) {
            windows++
            val maxRms = (0 until channels).maxOf { sqrt(winSumSq[it] / winFrames) }
            if (maxRms < SILENCE_RMS) silentWindows++
        }

        val leftRms = if (frameCount > 0) sqrt(sumSq[0] / frameCount) else 0.0
        val rightRms = if (channels > 1 && frameCount > 0) sqrt(sumSq[1] / frameCount) else leftRms
        val durationMs = header.durationMs
        val silenceRatio = if (windows > 0) silentWindows.toDouble() / windows else 1.0

        if (durationMs < MIN_VALID_DURATION_MS) {
            notes += "very short (${durationMs}ms)"
        }

        val leftAudible = leftRms >= AUDIBLE_RMS
        val rightAudible = rightRms >= AUDIBLE_RMS
        val bothSides = channels >= 2 && leftAudible && rightAudible

        val status = when {
            durationMs < MIN_VALID_DURATION_MS && silenceRatio > 0.98 -> RecordingStatus.SILENT
            silenceRatio >= 0.97 -> RecordingStatus.SILENT
            bothSides -> RecordingStatus.SUCCESS_BOTH_SIDES
            channels >= 2 && (leftAudible xor rightAudible) -> RecordingStatus.PARTIAL_ONE_SIDE
            channels == 1 && leftAudible -> RecordingStatus.PARTIAL_ONE_SIDE  // mono mic = one side only
            leftAudible || rightAudible -> RecordingStatus.PARTIAL_ONE_SIDE
            else -> RecordingStatus.SILENT
        }
        if (channels == 1 && status == RecordingStatus.PARTIAL_ONE_SIDE) {
            notes += "mono capture: both sides cannot be proven from a single channel"
        }

        return RecordingDiagnostics(
            strategy = strategy,
            status = status,
            outputPath = file.path,
            fileExists = true,
            fileSizeBytes = file.length(),
            durationMs = durationMs,
            decodable = true,
            channelCount = channels,
            sampleRate = header.sampleRate,
            leftEnergy = leftRms,
            rightEnergy = rightRms,
            silenceRatio = silenceRatio,
            bothSidesDetected = bothSides,
            audioSourceUsed = audioSource,
            errorReason = null,
            notes = notes,
        )
    }

    /** For non-PCM containers: duration/decodability only, no per-channel proof. */
    private fun validateOpaque(file: File, strategy: RecordingStrategy, audioSource: String?): RecordingDiagnostics {
        var durationMs = 0L
        var channels = 0
        var sampleRate = 0
        var decodable = false
        val retriever = MediaMetadataRetriever()
        try {
            retriever.setDataSource(file.path)
            durationMs = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0L
            sampleRate = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_SAMPLERATE)?.toIntOrNull() ?: 0
            channels = 0 // not reliably exposed by the retriever for audio-only files
            decodable = durationMs > 0
        } catch (t: Throwable) {
            return invalid(strategy, file.path, file.length(), "not decodable: ${t.message}")
        } finally {
            runCatching { retriever.release() }
        }
        val status = when {
            !decodable -> RecordingStatus.INVALID_FILE
            durationMs < MIN_VALID_DURATION_MS -> RecordingStatus.UNKNOWN
            else -> RecordingStatus.UNKNOWN // without PCM we cannot claim both/one/silent
        }
        return RecordingDiagnostics(
            strategy = strategy,
            status = status,
            outputPath = file.path,
            fileExists = true,
            fileSizeBytes = file.length(),
            durationMs = durationMs,
            decodable = decodable,
            channelCount = channels,
            sampleRate = sampleRate,
            leftEnergy = 0.0,
            rightEnergy = 0.0,
            silenceRatio = 0.0,
            bothSidesDetected = false,
            audioSourceUsed = audioSource,
            errorReason = if (decodable) null else "not decodable",
            notes = listOf("compressed container: per-channel presence not analysed"),
        )
    }

    private fun invalid(strategy: RecordingStrategy, path: String, size: Long, reason: String) =
        RecordingDiagnostics(
            strategy = strategy,
            status = RecordingStatus.INVALID_FILE,
            outputPath = path,
            fileExists = true,
            fileSizeBytes = size,
            durationMs = 0,
            decodable = false,
            channelCount = 0,
            sampleRate = 0,
            leftEnergy = 0.0,
            rightEnergy = 0.0,
            silenceRatio = 1.0,
            bothSidesDetected = false,
            audioSourceUsed = null,
            errorReason = reason,
        )
}
