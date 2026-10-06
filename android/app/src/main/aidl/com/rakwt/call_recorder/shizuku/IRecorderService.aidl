package com.rakwt.call_recorder.shizuku;

import android.os.ParcelFileDescriptor;

/**
 * Binder contract for the privileged recorder that runs inside the Shizuku-spawned process
 * (shell, uid 2000). The app drives it over this interface; the actual AudioRecord lives on the
 * far side where CAPTURE_AUDIO_OUTPUT / VOICE_CALL is permitted.
 */
interface IRecorderService {

    /**
     * Open an AudioRecord in the shell process and begin streaming interleaved 16-bit PCM back to
     * the caller through the returned pipe's read end.
     *
     * @param audioSource  a MediaRecorder.AudioSource value (e.g. VOICE_CALL=4).
     * @param sampleRate   e.g. 48000.
     * @param channelCount 1 (mono) or 2 (stereo — L=uplink / R=downlink on HALs that separate).
     * @return read end of a pipe carrying raw PCM, or null if the record could not be opened.
     */
    ParcelFileDescriptor startCapture(int audioSource, int sampleRate, int channelCount) = 1;

    /** Stop the capture and release the AudioRecord. */
    void stopCapture() = 2;

    boolean isCapturing() = 3;

    /** AudioRecord state after the last open attempt (1 = STATE_INITIALIZED). */
    int lastRecordState() = 4;

    /** Human-readable reason for the last failure, or null. */
    String lastError() = 5;

    /** Shizuku shutdown hook — must terminate the process. */
    void destroy() = 16777114;
}
