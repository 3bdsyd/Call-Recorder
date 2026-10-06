import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'database.g.dart';

/// One row per detected call. In Phase 1 a call maps to a single recording, so the recording and
/// its diagnostics live on the same row — deliberately not over-engineered. Phase 2 transcription
/// fields are present but unused until then.
class Calls extends Table {
  TextColumn get id => text()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get contactName => text().nullable()();
  TextColumn get direction => text()(); // CallDirection.wire
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationMs => integer().withDefault(const Constant(0))();

  TextColumn get recordingPath => text().nullable()();
  TextColumn get recordingStatus => text().withDefault(const Constant('unknown'))();
  TextColumn get recordingStrategy => text().withDefault(const Constant('unsupported'))();
  TextColumn get compatibilityColor => text().nullable()();

  // Diagnostics
  IntColumn get fileSizeBytes => integer().withDefault(const Constant(0))();
  IntColumn get channelCount => integer().withDefault(const Constant(0))();
  IntColumn get sampleRate => integer().withDefault(const Constant(0))();
  RealColumn get leftEnergy => real().withDefault(const Constant(0))();
  RealColumn get rightEnergy => real().withDefault(const Constant(0))();
  RealColumn get silenceRatio => real().withDefault(const Constant(0))();
  BoolColumn get bothSidesDetected => boolean().withDefault(const Constant(false))();
  TextColumn get audioSourceUsed => text().nullable()();
  TextColumn get errorReason => text().nullable()();
  TextColumn get notes => text().nullable()(); // json array

  // Phase 2 placeholders
  TextColumn get processingStatus => text().withDefault(const Constant('none'))();
  TextColumn get transcript => text().nullable()();
  TextColumn get summaryJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Calls])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  Future<List<Call>> allCalls() =>
      (select(calls)..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).get();

  Stream<List<Call>> watchCalls() =>
      (select(calls)..orderBy([(t) => OrderingTerm.desc(t.startedAt)])).watch();

  Future<Call?> callById(String id) =>
      (select(calls)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsertCall(CallsCompanion entry) =>
      into(calls).insertOnConflictUpdate(entry);

  Future<void> deleteCall(String id) =>
      (delete(calls)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'call_recorder.db'));
    return NativeDatabase.createInBackground(file);
  });
}
