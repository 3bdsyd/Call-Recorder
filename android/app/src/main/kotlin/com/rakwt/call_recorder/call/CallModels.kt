package com.rakwt.call_recorder.call

enum class CallDirection(val wire: String) {
    INCOMING("incoming"),
    OUTGOING("outgoing"),
    UNKNOWN("unknown");
}

/**
 * A single in-progress call. Direction is derived from the order of phone-state transitions:
 * a RINGING before OFFHOOK means incoming; OFFHOOK without a preceding RINGING means outgoing.
 * The direction is locked on the first non-IDLE transition so call-waiting can't flip it.
 */
data class CallSession(
    val id: String,
    var direction: CallDirection,
    var phoneNumber: String?,
    val startedAtMillis: Long,
    var endedAtMillis: Long? = null,
    var contactName: String? = null,
) {
    val durationMs: Long get() = (endedAtMillis ?: System.currentTimeMillis()) - startedAtMillis

    fun toMap(): Map<String, Any?> = mapOf(
        "id" to id,
        "direction" to direction.wire,
        "phoneNumber" to phoneNumber,
        "contactName" to contactName,
        "startedAtMillis" to startedAtMillis,
        "endedAtMillis" to endedAtMillis,
        "durationMs" to durationMs,
    )
}
