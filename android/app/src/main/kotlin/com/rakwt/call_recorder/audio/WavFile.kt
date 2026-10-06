package com.rakwt.call_recorder.audio

import java.io.File
import java.io.RandomAccessFile

/**
 * Minimal canonical PCM WAV (RIFF) reader/writer.
 *
 * We store Phase 1 recordings as 16-bit PCM WAV on purpose: it needs no decoder, it is universally
 * playable, and — crucially for the POC — it lets us measure per-channel energy directly, which is
 * how we tell "both sides" from "one side". Compressed formats (AAC/Opus) are a later optimisation.
 *
 * The header's size fields are rewritten on close, and can be re-derived from the file length, so a
 * recording that is hard-killed mid-call still yields a playable file.
 */
object WavFile {

    const val HEADER_SIZE = 44

    data class Header(
        val channels: Int,
        val sampleRate: Int,
        val bitsPerSample: Int,
        val dataBytes: Long,
    ) {
        val bytesPerFrame: Int get() = channels * (bitsPerSample / 8)
        val durationMs: Long
            get() = if (sampleRate > 0 && bytesPerFrame > 0)
                (dataBytes / bytesPerFrame) * 1000L / sampleRate else 0L
    }

    /** Write a 44-byte canonical header. Pass dataBytes=0 while recording; rewrite on close. */
    fun writeHeader(raf: RandomAccessFile, channels: Int, sampleRate: Int, bitsPerSample: Int, dataBytes: Long) {
        val byteRate = sampleRate * channels * bitsPerSample / 8
        val blockAlign = channels * bitsPerSample / 8
        val riffSize = 36 + dataBytes
        raf.seek(0)
        raf.write("RIFF".toByteArray(Charsets.US_ASCII))
        raf.writeIntLE((riffSize and 0xFFFFFFFFL).toInt())
        raf.write("WAVE".toByteArray(Charsets.US_ASCII))
        raf.write("fmt ".toByteArray(Charsets.US_ASCII))
        raf.writeIntLE(16)                 // PCM fmt chunk size
        raf.writeShortLE(1)                // audio format = PCM
        raf.writeShortLE(channels)
        raf.writeIntLE(sampleRate)
        raf.writeIntLE(byteRate)
        raf.writeShortLE(blockAlign)
        raf.writeShortLE(bitsPerSample)
        raf.write("data".toByteArray(Charsets.US_ASCII))
        raf.writeIntLE((dataBytes and 0xFFFFFFFFL).toInt())
    }

    /** Rewrite the RIFF/data size fields from the real file length. */
    fun finalizeHeader(file: File, channels: Int, sampleRate: Int, bitsPerSample: Int) {
        if (!file.exists()) return
        val dataBytes = (file.length() - HEADER_SIZE).coerceAtLeast(0)
        RandomAccessFile(file, "rw").use { raf ->
            writeHeader(raf, channels, sampleRate, bitsPerSample, dataBytes)
        }
    }

    fun readHeader(file: File): Header? {
        if (!file.exists() || file.length() < HEADER_SIZE) return null
        RandomAccessFile(file, "r").use { raf ->
            val riff = ByteArray(4); raf.read(riff)
            if (String(riff, Charsets.US_ASCII) != "RIFF") return null
            raf.seek(22)
            val channels = raf.readShortLE()
            val sampleRate = raf.readIntLE()
            raf.seek(34)
            val bits = raf.readShortLE()
            // Find the "data" chunk (tolerant of extra chunks).
            raf.seek(36)
            var dataBytes = file.length() - HEADER_SIZE
            val tag = ByteArray(4)
            if (raf.read(tag) == 4 && String(tag, Charsets.US_ASCII) == "data") {
                val declared = raf.readIntLE().toLong() and 0xFFFFFFFFL
                if (declared in 1..(file.length() - HEADER_SIZE)) dataBytes = declared
            }
            return Header(channels.coerceAtLeast(1), sampleRate, bits.coerceAtLeast(16), dataBytes)
        }
    }

    private fun RandomAccessFile.writeIntLE(v: Int) {
        write(v and 0xFF); write((v ushr 8) and 0xFF); write((v ushr 16) and 0xFF); write((v ushr 24) and 0xFF)
    }

    private fun RandomAccessFile.writeShortLE(v: Int) {
        write(v and 0xFF); write((v ushr 8) and 0xFF)
    }

    private fun RandomAccessFile.readShortLE(): Int {
        val a = read(); val b = read(); return (a and 0xFF) or ((b and 0xFF) shl 8)
    }

    private fun RandomAccessFile.readIntLE(): Int {
        val a = read(); val b = read(); val c = read(); val d = read()
        return (a and 0xFF) or ((b and 0xFF) shl 8) or ((c and 0xFF) shl 16) or ((d and 0xFF) shl 24)
    }
}
