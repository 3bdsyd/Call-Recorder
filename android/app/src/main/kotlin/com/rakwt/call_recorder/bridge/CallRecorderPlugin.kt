package com.rakwt.call_recorder.bridge

import android.content.Context
import com.rakwt.call_recorder.call.CallCoordinator
import com.rakwt.call_recorder.compatibility.CompatibilityProbe
import com.rakwt.call_recorder.recording.RecordingEngineFactory
import com.rakwt.call_recorder.recording.RecordingStrategy
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import rikka.shizuku.Shizuku

/**
 * The single seam between Flutter and the native recording layer.
 *
 *  - method channel  `call_recorder/methods` — commands & queries
 *  - event channel   `call_recorder/events`  — call + recording lifecycle events
 *  - event channel   `call_recorder/logs`    — structured native logs for the debug screen
 *
 * No telephony/audio code lives above this class on the Dart side.
 */
class CallRecorderPlugin(
    private val context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

    private val methods = MethodChannel(messenger, "call_recorder/methods")
    private val events = EventChannel(messenger, "call_recorder/events")
    private val logs = EventChannel(messenger, "call_recorder/logs")

    private var shizukuRequestCode = 0
    private val shizukuPermissionListener = Shizuku.OnRequestPermissionResultListener { code, grant ->
        pendingShizukuResult?.let {
            it.success(grant == android.content.pm.PackageManager.PERMISSION_GRANTED)
            pendingShizukuResult = null
        }
    }
    private var pendingShizukuResult: MethodChannel.Result? = null

    fun attach() {
        methods.setMethodCallHandler(this)
        events.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                CallCoordinator.eventSink = { map -> sink?.success(map) }
            }
            override fun onCancel(arguments: Any?) { CallCoordinator.eventSink = null }
        })
        logs.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                NativeLog.attachSink { map -> sink?.success(map) }
            }
            override fun onCancel(arguments: Any?) { NativeLog.detachSink() }
        })
        runCatching { Shizuku.addRequestPermissionResultListener(shizukuPermissionListener) }
    }

    fun detach() {
        methods.setMethodCallHandler(null)
        events.setStreamHandler(null)
        logs.setStreamHandler(null)
        runCatching { Shizuku.removeRequestPermissionResultListener(shizukuPermissionListener) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val app = context.applicationContext
        when (call.method) {
            "getDeviceInfo" -> result.success(CompatibilityProbe(app).deviceInfo())
            "getAvailableStrategies" ->
                result.success(RecordingEngineFactory(app).availableStrategies().map { it.wire })

            "isAutoRecord" -> result.success(CallCoordinator.isAutoRecord(app))
            "setAutoRecord" -> {
                CallCoordinator.setAutoRecord(app, call.argument<Boolean>("enabled") ?: false)
                result.success(true)
            }

            "getPreferredStrategy" -> result.success(CallCoordinator.preferredStrategy(app)?.wire)
            "setPreferredStrategy" -> {
                val wire = call.argument<String>("strategy")
                CallCoordinator.setPreferredStrategy(app, wire?.let { RecordingStrategy.fromWire(it) })
                result.success(true)
            }

            "manualStart" -> {
                call.argument<String>("strategy")?.let {
                    CallCoordinator.setPreferredStrategy(app, RecordingStrategy.fromWire(it))
                }
                CallCoordinator.manualStart(app)
                result.success(true)
            }
            "manualStop" -> {
                CallCoordinator.manualStop(app)
                result.success(true)
            }

            "saveCompatResult" -> {
                CompatibilityProbe(app).saveResult(
                    color = call.argument<String>("color") ?: "GRAY",
                    strategyWire = call.argument<String>("strategy") ?: "unknown",
                    status = call.argument<String>("status") ?: "unknown",
                )
                result.success(true)
            }

            "requestShizukuPermission" -> {
                try {
                    if (!Shizuku.pingBinder()) { result.success(false); return }
                    if (Shizuku.checkSelfPermission() == android.content.pm.PackageManager.PERMISSION_GRANTED) {
                        result.success(true); return
                    }
                    pendingShizukuResult = result
                    shizukuRequestCode += 1
                    Shizuku.requestPermission(shizukuRequestCode)
                } catch (t: Throwable) {
                    pendingShizukuResult = null
                    result.error("shizuku", t.message, null)
                }
            }

            "getNativeDiagnostics" -> result.success(CallCoordinator.diagnostics())

            else -> result.notImplemented()
        }
    }
}
