# مسجّل المكالمات — Call Recorder (Phase 1 POC)

A Flutter + Kotlin proof‑of‑concept that answers one question honestly:

> **Can *this* Android device reliably record BOTH sides of a normal cellular phone call?**

It auto‑detects incoming/outgoing calls, records them, saves the audio locally, lets you play it
back, and — crucially — **measures the audio and reports whether it captured both sides, one side,
silence, or failed**. It does **not** fake compatibility or hide Android's limitations.

Phase 2 (transcription + AI summaries) is scaffolded as interfaces only and is **not** implemented
yet.

> ⚠️ **Read [`docs/RESEARCH.md`](docs/RESEARCH.md) first.** It explains, from reading the source of
> five open‑source recorders, why both‑sides cellular recording needs shell‑level privilege
> (Shizuku), the OEM/HAL risks, and the exact strategy this project takes.

---

## What works in Phase 1

- **Call detection** — `PHONE_STATE` broadcast receiver; direction from the RINGING/OFFHOOK order;
  number/contact recovered from the call log.
- **Automatic recording** — a foreground service drives a pluggable recording engine for the
  duration of the call.
- **Two real engines + honest fallback:**
  - `PublicApiRecordingEngine` — in‑app `AudioRecord` from a MIC‑family source → WAV. Works
    everywhere, usually **one side** (this is Android's unprivileged reality, surfaced not hidden).
  - `ShizukuRecordingEngine` — opens `VOICE_CALL` (stereo) inside a Shizuku UserService running as
    the shell user, streams PCM back → WAV. **Both sides** when the device HAL allows.
  - `UnsupportedRecordingEngine` — never pretends to record.
- **Audio validation** — per‑channel RMS energy + silence analysis on the PCM → one of
  `SUCCESS_BOTH_SIDES / PARTIAL_ONE_SIDE / SILENT / INVALID_FILE / RECORDING_FAILED / UNKNOWN`.
- **Device compatibility test** (`اختبار توافق الجهاز`) — runs a **real** recording during a real
  call and classifies the result GREEN / YELLOW / RED / GRAY. Result is remembered per OS build.
- **Arabic‑first RTL UI** — Home, Call history, Call details, Player, Compatibility, Settings, and a
  developer Diagnostics log.
- **Local storage** — `…/recordings/<yyyy-MM-dd>/call_<ts>_<dir>_<number>.wav`; metadata in a Drift
  (SQLite) database. Nothing is uploaded.

## Architecture

```
Flutter UI / Riverpod / Drift DB  (lib/features, lib/core, lib/data)
        │   lib/platform/CallRecorderPlatform  ← the only Flutter↔native seam
        ▼
MethodChannel + 2× EventChannel   (android …/bridge/CallRecorderPlugin.kt)
        ▼
Kotlin native layer
  call/        PHONE_STATE detection, direction, call-log, coordinator
  service/     foreground service (microphone | specialUse)
  recording/   RecordingEngine + PublicApi / Shizuku / Unsupported + factory
  shizuku/     AIDL + shell-uid UserService (VOICE_CALL)
  audio/       WAV reader/writer + AudioValidator (both-sides decision)
  compatibility/ device probe + traffic-light classifier
  storage/     on-disk layout
```

Recording strategies are isolated behind `RecordingEngine`, so new ones (embedded ADB, root) can be
added without touching detection, storage, or UI.

## Build the APK

The cloud dev environment that scaffolded this **cannot reach the Android SDK host**, so build one
of these ways:

**A. GitHub Actions (recommended).** Push to any branch → the **Build APK** workflow produces
`app-debug.apk` and `app-release.apk` as downloadable artifacts. No local setup needed.

**B. Locally.** Requires Flutter 3.47.6 + Android SDK (compileSdk 36):

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates Drift code
flutter build apk --debug
# → build/app/outputs/flutter-apk/app-debug.apk
```

`minSdk 26` (Android 8). Release APK is debug‑signed for sideloading; add a real keystore before any
distribution.

## Using it on a phone (the Phase‑1 test)

1. Install the APK, open the app, grant the requested permissions (mic, phone, contacts,
   notifications) and disable battery optimization.
2. For **both‑sides** recording: install [Shizuku](https://github.com/RikkaApps/Shizuku), start it
   (wireless debugging / ADB — one time, re‑armed after each reboot), then grant this app Shizuku
   permission in Settings → *إذن Shizuku*.
3. Open **التوافق** (Compatibility), pick a strategy (or Auto), place a **real** call, tap **ابدأ
   الاختبار**, talk for a few seconds with the other party, then **أوقف الاختبار**.
4. The app analyses the audio and shows GREEN/YELLOW/RED/GRAY. Play the file back and **listen** to
   confirm.

> A recording existing is **not** success. Verify by listening that both participants are audible.

## Honest limitations

- No public Android API records both sides of a cellular call on Android 10+. Both‑sides needs
  Shizuku (shell UID). This technique is OEM/HAL‑dependent and known to break on new Android
  releases — the app reports failure rather than hiding it.
- Not Google‑Play compatible (`READ_CALL_LOG`, call recording). Target is sideloaded APKs on
  devices you control.
- Recording calls may be legally restricted / require consent in your jurisdiction.
- Recordings are stored as WAV in Phase 1 (needed for per‑channel analysis); AAC/Opus is a later
  optimisation.

## Licence / attribution

This is an independent, clean‑room implementation. Five open‑source recorders were studied for
technique only — **no code was copied** — see [`docs/NOTICES.md`](docs/NOTICES.md). Three of them are
GPL‑3.0 and were deliberately not reused as source.
