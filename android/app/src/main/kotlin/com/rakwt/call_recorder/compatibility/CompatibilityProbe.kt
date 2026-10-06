package com.rakwt.call_recorder.compatibility

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import com.rakwt.call_recorder.recording.RecordingDiagnostics
import com.rakwt.call_recorder.recording.RecordingEngineFactory
import com.rakwt.call_recorder.recording.RecordingStatus
import rikka.shizuku.Shizuku

/**
 * Reports what the device *offers* (APIs, Shizuku) and classifies the result of a *real* recording
 * test into a traffic-light verdict. Crucially, availability alone is never GREEN — only an actual
 * recording whose audio we measured can be GREEN. API availability without a test is GRAY.
 */
class CompatibilityProbe(private val context: Context) {

    private val prefs = context.getSharedPreferences("call_recorder_compat", Context.MODE_PRIVATE)

    fun deviceInfo(): Map<String, Any?> {
        val shizukuInstalled = isPackageInstalled("moe.shizuku.privileged.api")
        val shizukuRunning = runCatching { Shizuku.pingBinder() }.getOrDefault(false)
        val shizukuAuthorized = runCatching {
            shizukuRunning && Shizuku.checkSelfPermission() == PackageManager.PERMISSION_GRANTED
        }.getOrDefault(false)
        return mapOf(
            "manufacturer" to Build.MANUFACTURER,
            "brand" to Build.BRAND,
            "model" to Build.MODEL,
            "device" to Build.DEVICE,
            "androidRelease" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "fingerprint" to Build.FINGERPRINT,
            "availableStrategies" to RecordingEngineFactory(context).availableStrategies().map { it.wire },
            "shizukuInstalled" to shizukuInstalled,
            "shizukuRunning" to shizukuRunning,
            "shizukuAuthorized" to shizukuAuthorized,
            "savedResult" to savedResult(),
        )
    }

    private fun isPackageInstalled(pkg: String): Boolean = try {
        context.packageManager.getPackageInfo(pkg, 0); true
    } catch (e: PackageManager.NameNotFoundException) {
        false
    } catch (t: Throwable) {
        false
    }

    /**
     * Map a measured recording to a verdict colour:
     *  GREEN  — both sides present
     *  YELLOW — recording works but only one side captured
     *  RED    — failed / invalid
     *  GRAY   — silent or inconclusive; needs another real test
     */
    fun classify(diag: RecordingDiagnostics): String = when (diag.status) {
        RecordingStatus.SUCCESS_BOTH_SIDES -> "GREEN"
        RecordingStatus.PARTIAL_ONE_SIDE -> "YELLOW"
        RecordingStatus.RECORDING_FAILED, RecordingStatus.INVALID_FILE -> "RED"
        RecordingStatus.SILENT, RecordingStatus.UNKNOWN -> "GRAY"
    }

    fun saveResult(color: String, strategyWire: String, status: String) {
        prefs.edit()
            .putString("color", color)
            .putString("strategy", strategyWire)
            .putString("status", status)
            .putString("fingerprint", Build.FINGERPRINT)
            .putLong("testedAt", System.currentTimeMillis())
            .apply()
    }

    fun savedResult(): Map<String, Any?>? {
        val color = prefs.getString("color", null) ?: return null
        // Invalidate automatically when the OS build changed.
        if (prefs.getString("fingerprint", null) != Build.FINGERPRINT) return null
        return mapOf(
            "color" to color,
            "strategy" to prefs.getString("strategy", null),
            "status" to prefs.getString("status", null),
            "testedAt" to prefs.getLong("testedAt", 0),
        )
    }
}
