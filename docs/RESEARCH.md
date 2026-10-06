# Call Recording — Technical Research & Strategy (Phase 1)

> Produced before writing the recording engine, as requested. It is based on **reading the
> actual source** of the five reference projects (Kotlin/Java/AIDL), not their READMEs.
> Local clones were inspected; no source was copied into this repository. Three of the five
> are **GPL‑3.0** — their code cannot be copied into a proprietary/commercial codebase. The
> techniques below are described so they can be **re‑implemented independently**, which is
> legally permitted (an API technique is not copyrightable); copying their code is not.

## 0. The one conclusion that drives everything

**No public Android API can record both sides of a *cellular* call on Android 10+ (API 29+).**

`MediaRecorder.AudioSource.VOICE_CALL` (4), `VOICE_UPLINK` (2) and `VOICE_DOWNLINK` (3) are
gated behind `android.permission.CAPTURE_AUDIO_OUTPUT`, which has protection level
`signature|privileged`. A normal, sideloaded, or Play‑Store app **cannot hold it**. Using
`MIC` during a call captures, at best, the local microphone (your side) plus whatever the
earpiece/speaker leaks acoustically — i.e. *one side*, often degraded, and on many modern
devices nothing useful because the in‑call audio path is not exposed to `MIC`.

**All five reference projects reach the same conclusion and all five solve it the same way:**
they run the `AudioRecord` call **in a process whose UID is 2000 (the `shell` user)**. The
`shell` user, acting as the real system package `com.android.shell`, *does* hold
`CAPTURE_AUDIO_OUTPUT`/`RECORD_AUDIO`/`MODIFY_AUDIO_ROUTING` at signature level, so a
`VOICE_CALL` `AudioRecord` opened from that process succeeds. The only differences between the
projects are **(a)** how they obtain a shell‑UID process and **(b)** how they stream the audio
back to the app.

This is why the architecture *must* separate **call detection** (easy, public APIs) from
**call‑audio capture** (hard, requires elevated privilege). The app's compatibility system
exists precisely because even the privileged path returns silence or one‑side‑only audio on
many OEM audio HALs.

---

## 1. Project comparison

| | **ShizuCallRecorder** | **CallVault** | **CallMonitor‑Android** | **JemRec** | **Cally** |
|---|---|---|---|---|---|
| Repo owner | kitsumed | madkongo | alekseykidisyuk | jemcik | LyoSU |
| **License** | **GPL‑3.0 (+§7)** | **GPL‑3.0 (+§7)** | **GPL‑3.0 (+§7)** | **Apache‑2.0** | **GPL‑3.0** |
| Relationship | original | fork of ShizuCallRecorder | older snapshot of CallVault (`com.baba.callvault`) | independent | independent |
| **Recording API** | `AudioRecord` | `AudioRecord` | `AudioRecord` | `AudioRecord` | `AudioRecord` |
| **Audio source** | `VOICE_CALL` (default) + many selectable | `VOICE_CALL` + hidden‑API variants | same | `VOICE_CALL` (hard‑coded) | ladder: UPLINK+DOWNLINK → MIC+DOWNLINK → VOICE_CALL stereo → VOICE_CALL mono → MIC |
| **Privileged process via** | **Shizuku** *or* embedded wireless‑ADB; runs **scrcpy‑server v4.0** through `app_process` | **embedded on‑device ADB** (self‑pairing) *or* Shizuku | same as CallVault | **embedded on‑device ADB** (`libadb-android`); runs an **audio‑only scrcpy‑server fork** | **Shizuku** (`UserService`) |
| **Root required** | No (optional) | No | No | No | No (root used opportunistically) |
| **Shizuku required** | Yes, unless wireless‑ADB used | Optional | Optional | No (its own ADB) | **Yes** (primary path) |
| **PC/ADB required** | One‑time, or on‑device wireless debugging | On‑device only, no PC | On‑device only | On‑device only, no PC | One‑time to enable Shizuku (standard), then none |
| **Survives reboot** | No — Shizuku/ADB must be re‑armed | Re‑pair after reboot | same | Re‑pair (wireless debugging off after reboot) | No — Shizuku re‑activated after reboot; daemon then respawns |
| **Both‑side capture** | Yes, when HAL allows (`VOICE_CALL`) | Yes + stereo‑separation metering | Yes | Yes (`VOICE_CALL` stereo) | Yes, best‑effort via strategy ladder + verification |
| **Both‑side *verification*** | basic | **`StereoSeparation` per‑channel energy** | basic | presence check | **per‑stream adaptive‑floor RMS**, dual‑OK bitmask, half‑silent downgrade |
| **Compatibility learning** | — | some | — | — | **cache keyed on `Build.FINGERPRINT`, 3‑strike silence blacklist** |
| **Call detection** | `PHONE_STATE` receiver (+`READ_CALL_LOG` for number) + optional `InCallService` | same + VoIP app capture | same | `TelephonyCallback` **inside the shell daemon** (`READ_PRIVILEGED_PHONE_STATE`); number matched post‑hoc from `CallLog` | `PHONE_STATE` receiver only; number from `CallLog` post‑hoc; VoIP‑vs‑SIM discrimination |
| **minSdk / targetSdk** | 30 / 36 | 30 / 36 | 30 / 36 | 31 / 36 | 31 / 36 |
| **FGS type** | `dataSync\|specialUse` | `specialUse` | `specialUse` | `specialUse` (started by daemon via `am`) | `specialUse` |
| **Accessibility for audio** | No | No | No | No | **No** — only an *empty no‑op stub* used as an OEM FGS‑exemption hack |
| **Play‑Store distributable** | No | No | No | No | No (states so explicitly) |

### Useful (conceptual) components per project

- **ShizuCallRecorder** — clean Shizuku `UserService` + AIDL contract; `app_process` + `CLASSPATH`
  launch pattern; `LocalServerSocket` → kernel `pipe` → app relay; AppOps/role grants over shell
  (`appops set …`, grant `DIALER` role); two‑broadcast `PHONE_STATE` quirk (number only arrives in
  the second broadcast, which requires `READ_CALL_LOG`).
- **CallVault / CallMonitor** — stereo‑separation metering to *prove* both sides; OEM gate notices;
  self‑contained embedded‑ADB path (no Shizuku, no PC) for users who can't/won't install Shizuku.
- **JemRec** *(Apache‑2.0 — the only reusable‑by‑license one)* — `libadb-android` (SPAKE2 pairing +
  TLS over loopback) for PC‑free shell; waiting on `AudioManager.getMode()` to confirm the call is
  really up/down instead of trusting `IDLE`; post‑hoc `CallLog` matching window
  (3 min before / 30 s after); authenticated loopback socket with a shared token.
- **Cally** *(the most sophisticated capture engineering)* — **strategy ladder with live
  verification**, `Build.FINGERPRINT`‑keyed capability cache, adaptive per‑stream noise floor,
  dual‑OK bitmask, half‑silent Dual→Single downgrade, `daemon(true)` UserService that outlives the
  app, `getBypassHealth()` separating "can we capture at all" from "which strategy works",
  `OnModeChangedListener` to wait for the modem path, intent‑action state machine in the FGS to dodge
  the initial‑IDLE race, offline `AudioMixer` (soft‑pan for humans, RMS‑matched mono for STT).

---

## 2. Recommended strategy — and why

### 2.1 Capture (the hard part): a pluggable engine, Shizuku as the primary enhanced path

```
RecordingEngine (interface)
├── PublicApiRecordingEngine   → in-app AudioRecord/MediaRecorder, MIC-family sources only
│                                (works everywhere, usually ONE side; Play-policy aside, this is
│                                 the only strategy that needs no privilege)
├── ShizukuRecordingEngine     → AudioRecord(VOICE_CALL / UPLINK+DOWNLINK) inside a Shizuku
│                                UserService running as shell UID 2000; PCM back over a pipe
│                                (BOTH sides when the HAL allows)   ← PRIMARY enhanced path
├── ShellRecordingEngine       → same capture, but shell obtained via embedded on-device ADB
│                                (no Shizuku, no PC). Documented, deferred to Phase 1.5.
└── UnsupportedRecordingEngine  → device/API cannot do it; returns a clear RED result
```

**Why Shizuku first (not embedded ADB, not root):**

1. **Simplest correct implementation.** Shizuku already *is* the shell‑UID process; we only ship a
   tiny `UserService` + AIDL and bind to it. Embedded ADB means shipping an ADB client, SPAKE2
   pairing, a TLS stack, and the self‑pairing UX — a large, security‑sensitive surface
   (`libadb-android` itself ships with the caveat that it "has never had a security audit"). That is
   the right Phase‑1.5 upgrade, not the thing to prove the POC with.
2. **Cleanest clean‑room story.** The Shizuku `UserService`/`VOICE_CALL` technique is small, public,
   and widely documented; it can be re‑implemented from the specification without touching GPL code.
3. **No root** → no Verified Boot / Play Integrity breakage, no bootloader unlock, works on stock
   phones.
4. It is the single most common setup real testers already have.

**Why `PublicApiRecordingEngine` still exists:** it is the honest baseline. It will show the user,
on their own device, the typical "⚠ one side only / silence" reality of unprivileged recording —
which is exactly the question the POC must answer — and it is the only path with any chance of
Play‑Store life.

**We do not copy scrcpy‑server.** ShizuCallRecorder/CallVault/JemRec drive scrcpy‑server as the
shell‑side recorder. We don't need it: our shell‑side `UserService` opens `AudioRecord` directly
(the Cally approach), which is both simpler and avoids bundling a third‑party server binary. The
scrcpy‑derived Java in JemRec is Apache‑2.0 and *could* be reused with attribution, but a direct
`AudioRecord` `UserService` is less code and fully ours.

### 2.2 The capture technique the privileged engine must implement (independent re‑implementation)

Learned from the sources, to be built from scratch:

- Construct `AudioRecord` with the **`AudioRecord.Builder` + `setContext(...)` path (API 31+)** so
  the record picks up a shell/`com.android.shell` attribution. The legacy 5‑arg constructor reads
  attribution from process statics and silently fails AppOps under shell UID.
- Construct it **on a thread with a prepared `Looper` (the process main Looper)**, not on the Binder
  thread — otherwise `state == STATE_UNINITIALIZED`.
- Prefer **two mono records (UPLINK + DOWNLINK)** → offline mix to stereo; fall back to
  **MIC + DOWNLINK** (Samsung blocks UPLINK), then **`VOICE_CALL` stereo**, then **`VOICE_CALL`
  mono**, then **MIC only**. This ladder is the single most important reliability idea in the whole
  ecosystem.
- Stream PCM back to the app over a `ParcelFileDescriptor` reliable pipe; encode in‑app
  (AAC/`.m4a` via `MediaCodec`+`MediaMuxer`, or WAV with a rewritten header so a hard kill still
  leaves a playable file).

### 2.3 Detection (the easy part): `PHONE_STATE` + `CallLog`, no default dialer

- Manifest `BroadcastReceiver` for `android.intent.action.PHONE_STATE`. Direction from the
  `RINGING→OFFHOOK` (incoming) vs `OFFHOOK`‑without‑ring (outgoing) sequence.
- Number: request `READ_CALL_LOG`; the reliable number arrives in the *second* `PHONE_STATE`
  broadcast, and/or is recovered post‑call from `CallLog.Calls` (closest row within a time window).
- **Wait for `AudioManager.mode == MODE_IN_CALL/MODE_IN_COMMUNICATION`** (via `OnModeChangedListener`,
  with timeout) before opening audio, so we don't start before the modem path exists.
- Do **not** require becoming the default dialer and do **not** use an `InCallService` for Phase 1;
  `PHONE_STATE` is enough and keeps the permission surface small.
- Foreground service type **`specialUse`** (the mic access is in the shell process, and `specialUse`
  escapes the Android‑14 "FGS‑from‑background" restriction) with the required `PROPERTY_SPECIAL_USE_FGS_SUBTYPE`
  disclosure. On devices that block background FGS starts, keep Cally's 1×1 overlay trick as an
  optional, clearly‑disclosed fallback (requires `SYSTEM_ALERT_WINDOW`).

### 2.4 Both‑sides decision (the validation the POC lives or dies on)

Re‑implement Cally's approach:

- **Per‑stream adaptive noise floor** = median RMS of the first ~500 ms; a stream is "audible" if its
  RMS exceeds floor + ~6 dB.
- **Dual OK** only if *both* uplink and downlink streams are audible during a short verification
  window → `SUCCESS_BOTH_SIDES`.
- One stream audible, the other at floor → `PARTIAL_ONE_SIDE`.
- Both at floor → `SILENT`.
- Cache the working strategy per `Build.FINGERPRINT`; blacklist a silent strategy only after 3
  strikes (modem warm‑up is non‑deterministic); invalidate the cache automatically when the OS build
  changes.

---

## 3. Risks (stated plainly, not hidden)

**Android platform restrictions**
- `CAPTURE_AUDIO_OUTPUT` is `signature|privileged`; unprivileged apps *cannot* capture call audio.
  The whole both‑sides feature depends on a shell‑UID process. There is no public, unprivileged way.
- The shell‑UID/attribution technique is **explicitly fragile across releases** — Android 16 QPR1
  Beta already broke the same `AudioRecord.Builder`+fake‑package mechanism (scrcpy issue #6113).
  Treat it as "expected to break every 2–3 years," and surface failures loudly via a health signal.

**OEM / audio‑HAL differences**
- `VOICE_CALL` returns **silence** on many HALs; `VOICE_UPLINK` is **blocked on Samsung**; some HALs
  mix both sides into one mono stream; others expose only the uplink. The HAL can report `AudioRecord`
  "OK" and still deliver zeroes. This is *the* reason compatibility must be decided by a **real
  recording test**, never by API availability.

**Shizuku limitations**
- Requires one‑time activation (wireless debugging / ADB / root) and **does not survive reboot** on
  non‑rooted devices — the user re‑activates Shizuku after each reboot. The app must detect this and
  guide the user, not fail silently.

**Google Play policy**
- Call recording via these techniques is **not Play‑Store compatible**. `READ_CALL_LOG` is a
  restricted permission; impersonating `com.android.shell`, using an accessibility service for a
  non‑accessibility purpose, and non‑consensual recording all violate Play policy. **Target:
  sideloaded APK on controlled devices.** The architecture stays Play‑aware (the `PublicApiRecordingEngine`
  is the only remotely Play‑viable path, and even it is marginal), but Phase 1 does not target Play.

**Device‑compatibility risk**
- Realistically, a meaningful fraction of devices will land on **YELLOW** (one side) or **RED** (no
  reliable capture) even with Shizuku. The product must say so honestly per device.

**Legal / consent**
- Two‑party‑consent recording is illegal in many jurisdictions. The app must show a disclaimer and
  (where required) an in‑call notice. This is a product/compliance requirement, not just UX.

**This container**
- `dl.google.com` (the Android SDK package host) is **blocked by this environment's egress policy
  (HTTP 403)** and no SDK is pre‑installed, so the APK **cannot be compiled inside this cloud
  session**. The repository is therefore built to compile **(a)** on your machine with a normal
  Flutter/Android setup and **(b)** in **GitHub Actions CI**, which produces the installable APK
  artifact. There is also no physical phone here, so two‑sided audio **cannot be verified in this
  session** — that verification is Phase‑1's exit criterion and must be done on real hardware.

---

## 4. Phase 1 implementation plan (what this repo builds)

**Goal:** answer "can *this* device reliably record BOTH sides of a cellular call?" — nothing more.

**Native (Android/Kotlin), isolated from Flutter**
1. `call/` — `PhoneStateReceiver`, `CallSession` (direction + number via `CallLog`), `AudioModeGate`.
2. `service/` — `RecordingForegroundService` (`specialUse`), lifecycle, notifications.
3. `recording/` — `RecordingEngine` interface + `PublicApiRecordingEngine` (real, MIC‑family),
   `ShizukuRecordingEngine` (real, `UserService`+AIDL, `VOICE_CALL`/dual), `UnsupportedRecordingEngine`;
   `getRecordingDiagnostics()` returns structured data. Shizuku `UserService` + AIDL in a minimal
   privileged surface.
4. `compatibility/` — `DeviceInfo`, `CapabilityProbe` (what's *available*) **and** a real
   `RecordingTestRunner` (what *works*), cache keyed on `Build.FINGERPRINT`.
5. `storage/` — app‑specific `calls/<yyyy‑MM‑dd>/call_*.m4a`, never temp dirs.
6. `audio/` — `AudioValidator`: exists / size / duration / decodable / silence / per‑channel energy /
   both‑sides decision → `SUCCESS_BOTH_SIDES | PARTIAL_ONE_SIDE | SILENT | INVALID_FILE |
   RECORDING_FAILED | UNKNOWN`.
7. Structured native log stream (`CALL_STARTED`, `RECORDING_ENGINE_SELECTED`, …) surfaced to Flutter.

**Platform channel** — one `MethodChannel` (commands/queries) + one `EventChannel` (call events,
recording state, structured logs). A clean Dart `CallRecorderPlatform` abstraction; no telephony code
in widgets.

**Flutter**
- `core/` (theme, Arabic‑first RTL, logging), `data/` (Drift DB: calls, recordings, diagnostics),
  `domain/` (models + repositories), `presentation/` (Home, Call history, Call details, Player,
  Device compatibility "اختبار توافق الجهاز", Settings, Debug diagnostics).
- `Recording` model exactly as specified (id, phoneNumber, contactName, direction, startedAt,
  endedAt, duration, recordingPath, recordingStatus, recordingStrategy, compatibilityResult,
  createdAt, updatedAt).
- First‑run guided device test (permissions → Shizuku setup → test incoming → test outgoing →
  playback → confirm both sides → remember result).

**Phase 2 (stubbed as interfaces only, not implemented):** `SpeechToTextService`,
`CallAnalysisService` (Arabic‑first, structured JSON summary). No vendor hardcoded; no API key in the
APK — cloud AI will go through a backend later.

**Exit criteria (to be met on real hardware, not in this session):** build APK (via CI or locally) →
install → place a real cellular call → auto‑detect → record → save → play back → app reports
`SUCCESS_BOTH_SIDES` / `PARTIAL_ONE_SIDE` / `SILENT` / failure, verified by actually *listening*.

---

*References inspected (local clones, for technique study only; not copied):
kitsumed/ShizuCallRecorder (GPL‑3), madkongo/CallVault (GPL‑3), alekseykidisyuk/CallMonitor‑Android
(GPL‑3), jemcik/JemRec (Apache‑2.0), LyoSU/cally (GPL‑3).*
