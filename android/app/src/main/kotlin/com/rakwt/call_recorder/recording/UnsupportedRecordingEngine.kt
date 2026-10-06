package com.rakwt.call_recorder.recording

/** Terminal engine used when no strategy can run. It never pretends to record. */
class UnsupportedRecordingEngine(private val reason: String) : RecordingEngine {
    override val strategy = RecordingStrategy.UNSUPPORTED
    override fun isAvailable() = false
    override fun startRecording(request: RecordingRequest) = false
    override fun stopRecording() = RecordingDiagnostics.failed(strategy, reason)
    override fun isRecording() = false
    override fun currentOutputFile(): String? = null
    override fun validateRecording() = RecordingDiagnostics.failed(strategy, reason)
    override fun getRecordingDiagnostics() = mapOf("strategy" to strategy.wire, "reason" to reason)
    override fun release() {}
}
