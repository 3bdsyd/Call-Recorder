package com.rakwt.call_recorder.recording

/**
 * A pluggable call-audio capture strategy.
 *
 * Implementations are intentionally small and isolated from the rest of the app so new strategies
 * (embedded ADB, root, …) can be added without touching detection, storage, or UI. An engine does
 * exactly one job: turn "a call is active" into "PCM/compressed bytes on disk", and report honestly
 * what it managed to capture.
 */
interface RecordingEngine {

    /** Stable identifier used in logs, diagnostics and the DB. */
    val strategy: RecordingStrategy

    /**
     * Whether this engine can even be attempted on this device right now (permissions present,
     * Shizuku bound, API level high enough, …). This is a cheap check; it does NOT prove that the
     * resulting audio will contain anything — only a real recording test can do that.
     */
    fun isAvailable(): Boolean

    /**
     * Begin capturing. Returns true if capture started. Any thrown exception must be caught by the
     * implementation and turned into a false result + a diagnostics error reason.
     */
    fun startRecording(request: RecordingRequest): Boolean

    /**
     * Stop capturing and finalise the file. Returns diagnostics describing what was captured. Safe
     * to call even if [startRecording] failed or was never called.
     */
    fun stopRecording(): RecordingDiagnostics

    fun isRecording(): Boolean

    /** The file currently being (or last) written, if any. */
    fun currentOutputFile(): String?

    /**
     * Analyse whatever has been written so far / last written and return diagnostics without
     * stopping an in-progress recording. Used by the compatibility test harness.
     */
    fun validateRecording(): RecordingDiagnostics

    /** Human-oriented key/value diagnostics for the debug screen. */
    fun getRecordingDiagnostics(): Map<String, Any?>

    /** Release any held resources. Idempotent. */
    fun release()
}
