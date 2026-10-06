package com.rakwt.call_recorder.service

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import com.rakwt.call_recorder.call.CallCoordinator
import com.rakwt.call_recorder.bridge.NativeLog
import com.rakwt.call_recorder.recording.RecordingStrategy
import com.rakwt.call_recorder.recording.ShizukuRecordingEngine

/**
 * Keeps the process foreground-eligible for the duration of a recording so capture continues while
 * the app is backgrounded or the screen is locked.
 *
 * FGS type: when the privileged (Shizuku) path is chosen the microphone is held by the shell
 * process, so we declare `specialUse`; otherwise (app records from the mic) we declare `microphone`.
 */
class RecordingForegroundService : Service() {

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_START -> {
                startAsForeground()
                NativeLog.i("FGS_STARTED")
                runCatching { CallCoordinator.beginEngine(this) }
            }
            ACTION_STOP -> {
                runCatching { CallCoordinator.endEngine() }
                NativeLog.i("FGS_STOPPING")
                stopForegroundCompat()
                stopSelf()
            }
            else -> stopSelf()
        }
        return START_NOT_STICKY
    }

    private fun startAsForeground() {
        val notification = Notifications.build(this, "يتم الآن تسجيل صوت المكالمة")
        val shizukuChosen = runCatching { ShizukuRecordingEngine(this).isAvailable() }.getOrDefault(false)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val type = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE && shizukuChosen) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE
            } else {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            }
            try {
                startForeground(Notifications.NOTIFICATION_ID, notification, type)
            } catch (t: Throwable) {
                // Some OEMs reject a type from background; fall back to a typeless foreground.
                NativeLog.w("FGS_TYPE_FALLBACK", mapOf("reason" to t.message))
                startForeground(Notifications.NOTIFICATION_ID, notification)
            }
        } else {
            startForeground(Notifications.NOTIFICATION_ID, notification)
        }
    }

    private fun stopForegroundCompat() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE)
        } else {
            @Suppress("DEPRECATION") stopForeground(true)
        }
    }

    companion object {
        const val ACTION_START = "com.rakwt.call_recorder.START"
        const val ACTION_STOP = "com.rakwt.call_recorder.STOP"

        fun start(context: Context) {
            val intent = Intent(context, RecordingForegroundService::class.java).setAction(ACTION_START)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            val intent = Intent(context, RecordingForegroundService::class.java).setAction(ACTION_STOP)
            context.startService(intent)
        }
    }
}
