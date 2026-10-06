package com.rakwt.call_recorder.recording

/**
 * Which capture strategy produced (or attempted) a recording.
 *
 * Kept deliberately small for Phase 1. The names are stable wire values shared with Flutter.
 */
enum class RecordingStrategy(val wire: String) {
    PUBLIC_API("public_api"),      // in-app AudioRecord/MediaRecorder, MIC-family sources (usually one side)
    SHIZUKU_VOICE_CALL("shizuku_voice_call"), // VOICE_CALL via shell-uid Shizuku UserService
    SHIZUKU_DUAL("shizuku_dual"),  // UPLINK+DOWNLINK (or MIC+DOWNLINK) dual streams
    UNSUPPORTED("unsupported");

    companion object {
        fun fromWire(v: String?): RecordingStrategy =
            entries.firstOrNull { it.wire == v } ?: UNSUPPORTED
    }
}

/**
 * Outcome of validating a finished recording. Mirrors the Dart `RecordingStatus`.
 */
enum class RecordingStatus(val wire: String) {
    SUCCESS_BOTH_SIDES("success_both_sides"),
    PARTIAL_ONE_SIDE("partial_one_side"),
    SILENT("silent"),
    INVALID_FILE("invalid_file"),
    RECORDING_FAILED("recording_failed"),
    UNKNOWN("unknown");

    companion object {
        fun fromWire(v: String?): RecordingStatus =
            entries.firstOrNull { it.wire == v } ?: UNKNOWN
    }
}

/**
 * Structured diagnostics for a single recording attempt. Everything here is serialisable to a
 * plain map so it can cross the MethodChannel and be stored alongside the call.
 *
 * The POC's whole value is in these honest numbers — not in a boolean "it worked".
 */
data class RecordingDiagnostics(
    val strategy: RecordingStrategy,
    val status: RecordingStatus,
    val outputPath: String?,
    val fileExists: Boolean,
    val fileSizeBytes: Long,
    val durationMs: Long,
    val decodable: Boolean,
    val channelCount: Int,
    val sampleRate: Int,
    /** Normalised RMS energy [0..1] of the left/first channel. */
    val leftEnergy: Double,
    /** Normalised RMS energy [0..1] of the right/second channel (equals left for mono). */
    val rightEnergy: Double,
    /** Fraction [0..1] of analysed windows that were effectively silent. */
    val silenceRatio: Double,
    /** True once we have evidence that both the near and far side carry audio. */
    val bothSidesDetected: Boolean,
    val audioSourceUsed: String?,
    val errorReason: String?,
    val notes: List<String> = emptyList(),
) {
    fun toMap(): Map<String, Any?> = mapOf(
        "strategy" to strategy.wire,
        "status" to status.wire,
        "outputPath" to outputPath,
        "fileExists" to fileExists,
        "fileSizeBytes" to fileSizeBytes,
        "durationMs" to durationMs,
        "decodable" to decodable,
        "channelCount" to channelCount,
        "sampleRate" to sampleRate,
        "leftEnergy" to leftEnergy,
        "rightEnergy" to rightEnergy,
        "silenceRatio" to silenceRatio,
        "bothSidesDetected" to bothSidesDetected,
        "audioSourceUsed" to audioSourceUsed,
        "errorReason" to errorReason,
        "notes" to notes,
    )

    companion object {
        fun failed(
            strategy: RecordingStrategy,
            reason: String,
            outputPath: String? = null,
        ) = RecordingDiagnostics(
            strategy = strategy,
            status = RecordingStatus.RECORDING_FAILED,
            outputPath = outputPath,
            fileExists = false,
            fileSizeBytes = 0,
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
}

/** Parameters handed to an engine when a recording should start. */
data class RecordingRequest(
    val outputFile: String,
    val phoneNumber: String?,
    val isIncoming: Boolean,
    /** When true the engine should prefer a configuration that tries to capture both sides. */
    val wantBothSides: Boolean = true,
)
