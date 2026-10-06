import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/call_repository.dart';
import '../data/db/database.dart';
import '../platform/call_recorder_platform.dart';
import '../platform/native_models.dart';

final platformProvider = Provider<CallRecorderPlatform>((ref) => MethodChannelCallRecorder());

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final repo = CallRepository(ref.watch(databaseProvider), ref.watch(platformProvider));
  repo.start();
  ref.onDispose(repo.dispose);
  return repo;
});

/// Live list of stored calls, newest first.
final callsProvider = StreamProvider<List<Call>>((ref) {
  return ref.watch(callRepositoryProvider).watchCalls();
});

/// Device + capability snapshot (re-read on demand).
final deviceInfoProvider = FutureProvider.autoDispose<DeviceInfoData>((ref) {
  return ref.watch(platformProvider).getDeviceInfo();
});

/// Whether auto-record is enabled.
final autoRecordProvider = FutureProvider.autoDispose<bool>((ref) {
  return ref.watch(platformProvider).isAutoRecord();
});

/// Rolling buffer of native log lines for the debug screen.
final nativeLogProvider = StreamProvider.autoDispose<NativeLogEvent>((ref) {
  return ref.watch(platformProvider).logEvents();
});
