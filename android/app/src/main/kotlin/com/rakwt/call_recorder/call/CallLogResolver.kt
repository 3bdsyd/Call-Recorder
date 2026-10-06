package com.rakwt.call_recorder.call

import android.content.Context
import android.content.pm.PackageManager
import android.provider.CallLog
import android.provider.ContactsContract
import androidx.core.content.ContextCompat

/**
 * Recovers the phone number and contact name that the PHONE_STATE broadcast may withhold.
 *
 * On modern Android the number in the broadcast is blank for non-default-dialers, so we read the
 * most recent matching row from [CallLog] (within a short time window) and resolve the contact name
 * via PhoneLookup. Requires READ_CALL_LOG / READ_CONTACTS; absence degrades gracefully to null.
 */
class CallLogResolver(private val context: Context) {

    private fun has(permission: String) =
        ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED

    /** Most recent call-log number since [sinceMillis] minus a slop window. */
    fun mostRecentNumber(sinceMillis: Long): String? {
        if (!has(android.Manifest.permission.READ_CALL_LOG)) return null
        val slop = 60_000L
        return try {
            context.contentResolver.query(
                CallLog.Calls.CONTENT_URI,
                arrayOf(CallLog.Calls.NUMBER, CallLog.Calls.DATE),
                "${CallLog.Calls.DATE} >= ?",
                arrayOf((sinceMillis - slop).toString()),
                "${CallLog.Calls.DATE} DESC",
            )?.use { c ->
                if (c.moveToFirst()) c.getString(0)?.ifBlank { null } else null
            }
        } catch (t: Throwable) {
            null
        }
    }

    fun contactName(number: String?): String? {
        if (number.isNullOrBlank() || !has(android.Manifest.permission.READ_CONTACTS)) return null
        return try {
            val uri = ContactsContract.PhoneLookup.CONTENT_FILTER_URI.buildUpon()
                .appendPath(number).build()
            context.contentResolver.query(
                uri, arrayOf(ContactsContract.PhoneLookup.DISPLAY_NAME), null, null, null,
            )?.use { c -> if (c.moveToFirst()) c.getString(0) else null }
        } catch (t: Throwable) {
            null
        }
    }
}
