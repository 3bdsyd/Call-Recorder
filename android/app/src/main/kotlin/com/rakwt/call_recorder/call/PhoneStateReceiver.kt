package com.rakwt.call_recorder.call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import com.rakwt.call_recorder.bridge.NativeLog

/**
 * Receives android.intent.action.PHONE_STATE and forwards transitions to [CallCoordinator].
 *
 * The number arrives (when permitted) in EXTRA_INCOMING_NUMBER; on modern Android it is often null
 * and recovered later from the call log. We map the raw state string to our RINGING/OFFHOOK/IDLE
 * vocabulary and do nothing else here — all policy lives in the coordinator.
 */
class PhoneStateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != TelephonyManager.ACTION_PHONE_STATE_CHANGED) return
        val raw = intent.getStringExtra(TelephonyManager.EXTRA_STATE) ?: return
        val number = intent.getStringExtra(TelephonyManager.EXTRA_INCOMING_NUMBER)
        val state = when (raw) {
            TelephonyManager.EXTRA_STATE_RINGING -> "RINGING"
            TelephonyManager.EXTRA_STATE_OFFHOOK -> "OFFHOOK"
            TelephonyManager.EXTRA_STATE_IDLE -> "IDLE"
            else -> return
        }
        NativeLog.i("PHONE_STATE", mapOf("state" to state, "hasNumber" to (number != null)))
        CallCoordinator.onPhoneState(context.applicationContext, state, number)
    }
}
