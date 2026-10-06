package com.rakwt.call_recorder.call

import android.content.Context
import android.os.Handler
import android.os.Looper
import com.rakwt.call_recorder.bridge.NativeLog
import com.rakwt.call_recorder.recording.RecordingDiagnostics
import com.rakwt.call_recorder.recording.RecordingEngine
import com.rakwt.call_recorder.recording.RecordingEngineFactory
import com.rakwt.call_recorder.recording.RecordingRequest
import com.rakwt.call_recorder.recording.RecordingStrategy
import com.rakwt.call_recorder.service.RecordingForegroundService
import com.rakwt.call_recorder.storage.RecordingStorage
import java.util.UUID

/**
 * Single source of truth for the detect → record → validate → report flow. The broadcast receiver,
 * the foreground service and the Flutter bridge all talk to this object; none of them talk to each
 * other. This is the clean seam between "a call is happening" and "capture its audio".
 */
object CallCoordinator {

    private const val PREFS = "call_recorder_prefs"
    private const val KEY_AUTO = "auto_record"
    private const val KEY_STRATEGY = "preferred_strategy"

    private val main = Handler(Looper.getMainLooper())

    @Volatile var eventSink: ((Map<String, Any?>) -> Unit)? = null

    @Volatile private var session: CallSession? = null
    @Volatile private var engine: RecordingEngine? = null
    @Volatile private var lastRinging = false

    fun currentSession(): CallSession? = session

    // ---- configuration ---------------------------------------------------------------------

    fun isAutoRecord(context: Context): Boolean =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getBoolean(KEY_AUTO, false)

    fun setAutoRecord(context: Context, enabled: Boolean) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().putBoolean(KEY_AUTO, enabled).apply()
    }

    fun preferredStrategy(context: Context): RecordingStrategy? {
        val v = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).getString(KEY_STRATEGY, null)
        return v?.let { RecordingStrategy.fromWire(it) }
    }

    fun setPreferredStrategy(context: Context, strategy: RecordingStrategy?) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
            .putString(KEY_STRATEGY, strategy?.wire).apply()
    }

    // ---- detection state machine (called by PhoneStateReceiver) ----------------------------

    fun onPhoneState(context: Context, state: String, incomingNumber: String?) {
        when (state) {
            "RINGING" -> {
                lastRinging = true
                if (session == null) {
                    startSession(CallDirection.INCOMING, incomingNumber)
                }
            }
            "OFFHOOK" -> {
                if (session == null) {
                    startSession(CallDirection.OUTGOING, incomingNumber)
                }
                session?.let { s ->
                    if (s.phoneNumber.isNullOrBlank() && !incomingNumber.isNullOrBlank()) {
                        s.phoneNumber = incomingNumber
                    }
                    emitCallEvent("CALL_STARTED", s)
                    // Give the number-bearing broadcast / call-log a moment, then start recording.
                    main.postDelayed({ resolveNumberAndMaybeRecord(context, s) }, 800)
                }
            }
            "IDLE" -> {
                lastRinging = false
                val s = session ?: return
                s.endedAtMillis = System.currentTimeMillis()
                stopRecording(context)
                emitCallEvent("CALL_ENDED", s)
                session = null
            }
        }
    }

    private fun startSession(direction: CallDirection, number: String?) {
        session = CallSession(
            id = UUID.randomUUID().toString(),
            direction = direction,
            phoneNumber = number?.ifBlank { null },
            startedAtMillis = System.currentTimeMillis(),
        )
        NativeLog.i("CALL_DETECTED", session!!.toMap())
    }

    private fun resolveNumberAndMaybeRecord(context: Context, s: CallSession) {
        if (session?.id != s.id) return
        val resolver = CallLogResolver(context)
        if (s.phoneNumber.isNullOrBlank()) {
            s.phoneNumber = resolver.mostRecentNumber(s.startedAtMillis)
        }
        if (s.contactName.isNullOrBlank()) {
            s.contactName = resolver.contactName(s.phoneNumber)
        }
        if (isAutoRecord(context)) {
            RecordingForegroundService.start(context)
        }
    }

    // ---- recording lifecycle (invoked from the foreground service) -------------------------

    /** Called by the service once it is in the foreground, so mic access is legal while backgrounded. */
    fun beginEngine(context: Context) {
        if (engine?.isRecording() == true) return
        val s = session ?: return
        val factory = RecordingEngineFactory(context.applicationContext)
        val eng = factory.create(preferredStrategy(context))
        engine = eng
        NativeLog.i("RECORDING_ENGINE_SELECTED", mapOf("strategy" to eng.strategy.wire, "callId" to s.id))
        val storage = RecordingStorage(context.applicationContext)
        val file = storage.newRecordingFile(s.direction == CallDirection.INCOMING, s.phoneNumber)
        val ok = eng.startRecording(
            RecordingRequest(file.path, s.phoneNumber, s.direction == CallDirection.INCOMING)
        )
        if (!ok) {
            val diag = eng.stopRecording()
            emitRecordingCompleted(s, diag)
        }
    }

    private fun stopRecording(context: Context) {
        RecordingForegroundService.stop(context)
    }

    /** Called by the service when it is tearing down; finalises and reports. */
    fun endEngine(): Pair<CallSession, RecordingDiagnostics>? {
        val eng = engine ?: return null
        val s = session ?: currentSessionSnapshot
        engine = null
        val diag = eng.stopRecording()
        eng.release()
        if (s != null) {
            emitRecordingCompleted(s, diag)
            return s to diag
        }
        return null
    }

    // Keep a snapshot so a late IDLE after session cleared still reports.
    @Volatile private var currentSessionSnapshot: CallSession? = null

    fun manualStart(context: Context) {
        if (session == null) startSession(CallDirection.UNKNOWN, null)
        RecordingForegroundService.start(context)
    }

    fun manualStop(context: Context) {
        session?.let { it.endedAtMillis = System.currentTimeMillis() }
        RecordingForegroundService.stop(context)
    }

    fun diagnostics(): Map<String, Any?> = mapOf(
        "hasSession" to (session != null),
        "session" to session?.toMap(),
        "engine" to engine?.getRecordingDiagnostics(),
    )

    // ---- event emission --------------------------------------------------------------------

    private fun emitCallEvent(event: String, s: CallSession) {
        currentSessionSnapshot = s
        emit(mapOf("type" to event) + s.toMap())
    }

    private fun emitRecordingCompleted(s: CallSession, diag: RecordingDiagnostics) {
        NativeLog.i("RECORDING_STATUS", mapOf("status" to diag.status.wire, "callId" to s.id))
        emit(mapOf("type" to "RECORDING_COMPLETED") + s.toMap() + mapOf("diagnostics" to diag.toMap()))
    }

    private fun emit(data: Map<String, Any?>) {
        main.post { runCatching { eventSink?.invoke(data) } }
    }
}
