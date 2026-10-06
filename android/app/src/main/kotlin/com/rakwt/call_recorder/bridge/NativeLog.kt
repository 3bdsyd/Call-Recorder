package com.rakwt.call_recorder.bridge

import android.util.Log
import org.json.JSONObject

/**
 * Structured logging for the native recording layer.
 *
 * Every significant transition emits one structured event (CALL_STARTED, RECORDING_ENGINE_SELECTED,
 * RECORDING_STARTED, …). Events go to logcat (tag "CallRec") and, when the EventChannel is attached,
 * are streamed to the Flutter debug/diagnostics screen. We do not spam: only state transitions and
 * errors are logged, not per-buffer noise.
 */
object NativeLog {

    const val TAG = "CallRec"

    @Volatile
    private var sink: ((Map<String, Any?>) -> Unit)? = null

    fun attachSink(s: (Map<String, Any?>) -> Unit) { sink = s }
    fun detachSink() { sink = null }

    fun event(event: String, level: String = "info", data: Map<String, Any?> = emptyMap()) {
        val record = buildMap<String, Any?> {
            put("ts", System.currentTimeMillis())
            put("event", event)
            put("level", level)
            putAll(data)
        }
        val json = JSONObject(record.mapValues { it.value ?: JSONObject.NULL }).toString()
        when (level) {
            "error" -> Log.e(TAG, json)
            "warn" -> Log.w(TAG, json)
            else -> Log.i(TAG, json)
        }
        runCatching { sink?.invoke(record) }
    }

    fun i(event: String, data: Map<String, Any?> = emptyMap()) = event(event, "info", data)
    fun w(event: String, data: Map<String, Any?> = emptyMap()) = event(event, "warn", data)
    fun e(event: String, data: Map<String, Any?> = emptyMap()) = event(event, "error", data)
}
