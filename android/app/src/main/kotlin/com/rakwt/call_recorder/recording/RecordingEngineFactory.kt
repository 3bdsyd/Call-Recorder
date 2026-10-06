package com.rakwt.call_recorder.recording

import android.content.Context

/**
 * Picks an engine. Preference order for "best available both-sides attempt":
 *   1. Shizuku (shell-uid VOICE_CALL) when available/authorised.
 *   2. Public-API MIC baseline (works everywhere, usually one side).
 *   3. Unsupported.
 *
 * The caller can also force a specific strategy (used by the compatibility test harness, which
 * deliberately exercises each path in turn).
 */
class RecordingEngineFactory(private val context: Context) {

    fun create(preferred: RecordingStrategy? = null): RecordingEngine {
        return when (preferred) {
            RecordingStrategy.PUBLIC_API -> PublicApiRecordingEngine(context)
            RecordingStrategy.SHIZUKU_VOICE_CALL,
            RecordingStrategy.SHIZUKU_DUAL -> ShizukuRecordingEngine(context)
            RecordingStrategy.UNSUPPORTED -> UnsupportedRecordingEngine("forced unsupported")
            null -> best()
        }
    }

    private fun best(): RecordingEngine {
        val shizuku = ShizukuRecordingEngine(context)
        if (shizuku.isAvailable()) return shizuku
        val public = PublicApiRecordingEngine(context)
        if (public.isAvailable()) return public
        return UnsupportedRecordingEngine("no recording permission and Shizuku unavailable")
    }

    fun availableStrategies(): List<RecordingStrategy> {
        val out = mutableListOf<RecordingStrategy>()
        if (ShizukuRecordingEngine(context).isAvailable()) out += RecordingStrategy.SHIZUKU_VOICE_CALL
        if (PublicApiRecordingEngine(context).isAvailable()) out += RecordingStrategy.PUBLIC_API
        if (out.isEmpty()) out += RecordingStrategy.UNSUPPORTED
        return out
    }
}
