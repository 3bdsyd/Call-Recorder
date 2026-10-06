# Third‑party research notices

This project is an **independent, clean‑room implementation**. The following open‑source call
recorders were **inspected (source read) for technique only**. **No source code from them was copied
into this repository.** They are listed to give credit for the ideas and to be transparent about
what was studied.

| Project | Author | Licence | How it was used |
|---|---|---|---|
| [ShizuCallRecorder](https://github.com/kitsumed/ShizuCallRecorder) | kitsumed (Med) | **GPL‑3.0 (+§7)** | Technique study only — Shizuku UserService + `app_process`/scrcpy pattern, AppOps grants, PHONE_STATE double‑broadcast. Not reused as source (GPL). |
| [CallVault](https://github.com/madkongo/CallVault) | madkongo | **GPL‑3.0 (+§7)** | Technique study only — embedded on‑device ADB, stereo‑separation verification, OEM gates. Not reused as source (GPL). |
| [CallMonitor‑Android](https://github.com/alekseykidisyuk/CallMonitor-Android) | alekseykidisyuk | **GPL‑3.0 (+§7)** | Technique study only — earlier snapshot of CallVault. Not reused as source (GPL). |
| [JemRec](https://github.com/jemcik/JemRec) | jemcik | **Apache‑2.0** | Technique study only — embedded ADB pairing (`libadb-android`), `AudioManager.getMode()` call confirmation, post‑hoc call‑log matching. Apache‑2.0 would permit reuse with attribution; we still re‑implemented independently. |
| [Cally](https://github.com/LyoSU/cally) | LyoSU | **GPL‑3.0** | Technique study only — strategy ladder with live verification, `Build.FINGERPRINT` capability cache, adaptive noise‑floor silence detection, dual‑OK decision. Not reused as source (GPL). |

## Why no copying

The three GPL‑3.0 projects are incompatible with a proprietary/commercial architecture, so their
source is off‑limits. An API‑level *technique* (e.g. "open `AudioRecord(VOICE_CALL)` from a shell‑UID
process") is not itself copyrightable and was re‑implemented from scratch here. If any of these
projects' specific code is ever needed verbatim, it must not be added to this repository without
resolving the licence (and JemRec's Apache‑2.0 `NOTICE` obligations) first.

## Runtime dependency

- **Shizuku** (`dev.rikka.shizuku:api`, `:provider`) is used at runtime as an optional privilege
  provider. Shizuku is MIT/Apache‑licensed and is depended on as a normal library/service, not
  copied.
