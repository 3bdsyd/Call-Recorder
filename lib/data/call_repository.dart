import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/enums.dart';
import '../platform/call_recorder_platform.dart';
import '../platform/native_models.dart';
import 'db/database.dart';

/// Bridges native call/recording events into the local database and exposes calls to the UI.
///
/// The native layer is the source of truth for "what happened on the phone"; this repository is the
/// source of truth for "what we remember". It persists a minimal row when a call starts and fills in
/// the recording + diagnostics when the recording completes.
class CallRepository {
  CallRepository(this._db, this._platform);

  final AppDatabase _db;
  final CallRecorderPlatform _platform;
  StreamSubscription<NativeCallEvent>? _sub;

  /// The most recent completed recording, surfaced for the compatibility flow.
  final StreamController<NativeCallEvent> _completed = StreamController.broadcast();
  Stream<NativeCallEvent> get completedRecordings => _completed.stream;

  void start() {
    _sub ??= _platform.callEvents().listen(_onEvent, onError: (_) {});
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _completed.close();
  }

  Stream<List<Call>> watchCalls() => _db.watchCalls();
  Future<Call?> callById(String id) => _db.callById(id);
  Future<void> deleteCall(String id) => _db.deleteCall(id);

  Future<void> _onEvent(NativeCallEvent e) async {
    final id = e.callId;
    if (id == null) return;
    final started = e.startedAtMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(e.startedAtMillis!)
        : DateTime.now();

    switch (e.type) {
      case 'CALL_STARTED':
        await _db.upsertCall(CallsCompanion.insert(
          id: id,
          direction: e.direction.wire,
          startedAt: started,
          phoneNumber: Value(e.phoneNumber),
          contactName: Value(e.contactName),
        ));
      case 'CALL_ENDED':
        final existing = await _db.callById(id);
        await _db.upsertCall(CallsCompanion(
          id: Value(id),
          direction: Value(e.direction.wire),
          startedAt: Value(started),
          endedAt: Value(e.endedAtMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(e.endedAtMillis!)
              : DateTime.now()),
          durationMs: Value(e.durationMs),
          phoneNumber: Value(e.phoneNumber ?? existing?.phoneNumber),
          contactName: Value(e.contactName ?? existing?.contactName),
          updatedAt: Value(DateTime.now()),
        ));
      case 'RECORDING_COMPLETED':
        final d = e.diagnostics;
        final color = d != null ? CompatColor.fromStatus(d.status) : CompatColor.gray;
        await _db.upsertCall(CallsCompanion(
          id: Value(id),
          direction: Value(e.direction.wire),
          startedAt: Value(started),
          endedAt: Value(e.endedAtMillis != null
              ? DateTime.fromMillisecondsSinceEpoch(e.endedAtMillis!)
              : DateTime.now()),
          durationMs: Value(e.durationMs),
          phoneNumber: Value(e.phoneNumber),
          contactName: Value(e.contactName),
          recordingPath: Value(d?.outputPath),
          recordingStatus: Value((d?.status ?? RecordingStatus.unknown).wire),
          recordingStrategy: Value((d?.strategy ?? RecordingStrategy.unsupported).wire),
          compatibilityColor: Value(color.wire),
          fileSizeBytes: Value(d?.fileSizeBytes ?? 0),
          channelCount: Value(d?.channelCount ?? 0),
          sampleRate: Value(d?.sampleRate ?? 0),
          leftEnergy: Value(d?.leftEnergy ?? 0),
          rightEnergy: Value(d?.rightEnergy ?? 0),
          silenceRatio: Value(d?.silenceRatio ?? 0),
          bothSidesDetected: Value(d?.bothSidesDetected ?? false),
          audioSourceUsed: Value(d?.audioSourceUsed),
          errorReason: Value(d?.errorReason),
          notes: Value(d != null ? jsonEncode(d.notes) : null),
          updatedAt: Value(DateTime.now()),
        ));
        if (!_completed.isClosed) _completed.add(e);
    }
  }
}
