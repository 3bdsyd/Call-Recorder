package com.rakwt.call_recorder.call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.rakwt.call_recorder.bridge.NativeLog

/**
 * On boot we only log readiness. The PHONE_STATE receiver is manifest-registered, so detection is
 * armed again automatically; there is no persistent process to restart for the Phase 1 engines.
 * (A Shizuku session must be re-activated by the user after reboot — surfaced in the UI, not here.)
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            NativeLog.i("BOOT_COMPLETED")
        }
    }
}
