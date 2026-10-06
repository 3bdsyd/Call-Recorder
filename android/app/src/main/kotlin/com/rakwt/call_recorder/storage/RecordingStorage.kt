package com.rakwt.call_recorder.storage

import android.content.Context
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Owns the on-disk layout for recordings. Files live under the app-specific external files dir:
 *
 *   <app files>/recordings/<yyyy-MM-dd>/call_<timestamp>_<dir>_<number>.wav
 *
 * App-specific storage needs no runtime storage permission and is cleaned up on uninstall. We never
 * write to random temp dirs.
 */
class RecordingStorage(private val context: Context) {

    private val dayFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
    private val tsFormat = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US)

    fun baseDir(): File {
        val base = File(context.getExternalFilesDir(null) ?: context.filesDir, "recordings")
        if (!base.exists()) base.mkdirs()
        return base
    }

    fun newRecordingFile(isIncoming: Boolean, phoneNumber: String?, extension: String = "wav"): File {
        val now = Date()
        val dayDir = File(baseDir(), dayFormat.format(now))
        if (!dayDir.exists()) dayDir.mkdirs()
        val dir = if (isIncoming) "in" else "out"
        val safeNumber = (phoneNumber ?: "unknown")
            .replace(Regex("[^0-9+]"), "")
            .ifEmpty { "unknown" }
            .take(20)
        return File(dayDir, "call_${tsFormat.format(now)}_${dir}_$safeNumber.$extension")
    }

    /** A scratch file used only by the compatibility test harness. */
    fun compatTestFile(extension: String = "wav"): File {
        val dir = File(baseDir(), "_compat_test")
        if (!dir.exists()) dir.mkdirs()
        return File(dir, "compat_${tsFormat.format(Date())}.$extension")
    }

    fun deleteCompatTests() {
        File(baseDir(), "_compat_test").deleteRecursively()
    }
}
