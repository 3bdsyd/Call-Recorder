// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CallsTable extends Calls with TableInfo<$CallsTable, Call> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CallsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactNameMeta = const VerificationMeta(
    'contactName',
  );
  @override
  late final GeneratedColumn<String> contactName = GeneratedColumn<String>(
    'contact_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _recordingPathMeta = const VerificationMeta(
    'recordingPath',
  );
  @override
  late final GeneratedColumn<String> recordingPath = GeneratedColumn<String>(
    'recording_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordingStatusMeta = const VerificationMeta(
    'recordingStatus',
  );
  @override
  late final GeneratedColumn<String> recordingStatus = GeneratedColumn<String>(
    'recording_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _recordingStrategyMeta = const VerificationMeta(
    'recordingStrategy',
  );
  @override
  late final GeneratedColumn<String> recordingStrategy =
      GeneratedColumn<String>(
        'recording_strategy',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unsupported'),
      );
  static const VerificationMeta _compatibilityColorMeta =
      const VerificationMeta('compatibilityColor');
  @override
  late final GeneratedColumn<String> compatibilityColor =
      GeneratedColumn<String>(
        'compatibility_color',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _channelCountMeta = const VerificationMeta(
    'channelCount',
  );
  @override
  late final GeneratedColumn<int> channelCount = GeneratedColumn<int>(
    'channel_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sampleRateMeta = const VerificationMeta(
    'sampleRate',
  );
  @override
  late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
    'sample_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _leftEnergyMeta = const VerificationMeta(
    'leftEnergy',
  );
  @override
  late final GeneratedColumn<double> leftEnergy = GeneratedColumn<double>(
    'left_energy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rightEnergyMeta = const VerificationMeta(
    'rightEnergy',
  );
  @override
  late final GeneratedColumn<double> rightEnergy = GeneratedColumn<double>(
    'right_energy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _silenceRatioMeta = const VerificationMeta(
    'silenceRatio',
  );
  @override
  late final GeneratedColumn<double> silenceRatio = GeneratedColumn<double>(
    'silence_ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bothSidesDetectedMeta = const VerificationMeta(
    'bothSidesDetected',
  );
  @override
  late final GeneratedColumn<bool> bothSidesDetected = GeneratedColumn<bool>(
    'both_sides_detected',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("both_sides_detected" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _audioSourceUsedMeta = const VerificationMeta(
    'audioSourceUsed',
  );
  @override
  late final GeneratedColumn<String> audioSourceUsed = GeneratedColumn<String>(
    'audio_source_used',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorReasonMeta = const VerificationMeta(
    'errorReason',
  );
  @override
  late final GeneratedColumn<String> errorReason = GeneratedColumn<String>(
    'error_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processingStatusMeta = const VerificationMeta(
    'processingStatus',
  );
  @override
  late final GeneratedColumn<String> processingStatus = GeneratedColumn<String>(
    'processing_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _transcriptMeta = const VerificationMeta(
    'transcript',
  );
  @override
  late final GeneratedColumn<String> transcript = GeneratedColumn<String>(
    'transcript',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryJsonMeta = const VerificationMeta(
    'summaryJson',
  );
  @override
  late final GeneratedColumn<String> summaryJson = GeneratedColumn<String>(
    'summary_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    contactName,
    direction,
    startedAt,
    endedAt,
    durationMs,
    recordingPath,
    recordingStatus,
    recordingStrategy,
    compatibilityColor,
    fileSizeBytes,
    channelCount,
    sampleRate,
    leftEnergy,
    rightEnergy,
    silenceRatio,
    bothSidesDetected,
    audioSourceUsed,
    errorReason,
    notes,
    processingStatus,
    transcript,
    summaryJson,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calls';
  @override
  VerificationContext validateIntegrity(
    Insertable<Call> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('contact_name')) {
      context.handle(
        _contactNameMeta,
        contactName.isAcceptableOrUnknown(
          data['contact_name']!,
          _contactNameMeta,
        ),
      );
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('recording_path')) {
      context.handle(
        _recordingPathMeta,
        recordingPath.isAcceptableOrUnknown(
          data['recording_path']!,
          _recordingPathMeta,
        ),
      );
    }
    if (data.containsKey('recording_status')) {
      context.handle(
        _recordingStatusMeta,
        recordingStatus.isAcceptableOrUnknown(
          data['recording_status']!,
          _recordingStatusMeta,
        ),
      );
    }
    if (data.containsKey('recording_strategy')) {
      context.handle(
        _recordingStrategyMeta,
        recordingStrategy.isAcceptableOrUnknown(
          data['recording_strategy']!,
          _recordingStrategyMeta,
        ),
      );
    }
    if (data.containsKey('compatibility_color')) {
      context.handle(
        _compatibilityColorMeta,
        compatibilityColor.isAcceptableOrUnknown(
          data['compatibility_color']!,
          _compatibilityColorMeta,
        ),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('channel_count')) {
      context.handle(
        _channelCountMeta,
        channelCount.isAcceptableOrUnknown(
          data['channel_count']!,
          _channelCountMeta,
        ),
      );
    }
    if (data.containsKey('sample_rate')) {
      context.handle(
        _sampleRateMeta,
        sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
      );
    }
    if (data.containsKey('left_energy')) {
      context.handle(
        _leftEnergyMeta,
        leftEnergy.isAcceptableOrUnknown(data['left_energy']!, _leftEnergyMeta),
      );
    }
    if (data.containsKey('right_energy')) {
      context.handle(
        _rightEnergyMeta,
        rightEnergy.isAcceptableOrUnknown(
          data['right_energy']!,
          _rightEnergyMeta,
        ),
      );
    }
    if (data.containsKey('silence_ratio')) {
      context.handle(
        _silenceRatioMeta,
        silenceRatio.isAcceptableOrUnknown(
          data['silence_ratio']!,
          _silenceRatioMeta,
        ),
      );
    }
    if (data.containsKey('both_sides_detected')) {
      context.handle(
        _bothSidesDetectedMeta,
        bothSidesDetected.isAcceptableOrUnknown(
          data['both_sides_detected']!,
          _bothSidesDetectedMeta,
        ),
      );
    }
    if (data.containsKey('audio_source_used')) {
      context.handle(
        _audioSourceUsedMeta,
        audioSourceUsed.isAcceptableOrUnknown(
          data['audio_source_used']!,
          _audioSourceUsedMeta,
        ),
      );
    }
    if (data.containsKey('error_reason')) {
      context.handle(
        _errorReasonMeta,
        errorReason.isAcceptableOrUnknown(
          data['error_reason']!,
          _errorReasonMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('processing_status')) {
      context.handle(
        _processingStatusMeta,
        processingStatus.isAcceptableOrUnknown(
          data['processing_status']!,
          _processingStatusMeta,
        ),
      );
    }
    if (data.containsKey('transcript')) {
      context.handle(
        _transcriptMeta,
        transcript.isAcceptableOrUnknown(data['transcript']!, _transcriptMeta),
      );
    }
    if (data.containsKey('summary_json')) {
      context.handle(
        _summaryJsonMeta,
        summaryJson.isAcceptableOrUnknown(
          data['summary_json']!,
          _summaryJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Call map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Call(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      contactName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_name'],
      ),
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      recordingPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_path'],
      ),
      recordingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_status'],
      )!,
      recordingStrategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_strategy'],
      )!,
      compatibilityColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}compatibility_color'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      channelCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}channel_count'],
      )!,
      sampleRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sample_rate'],
      )!,
      leftEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left_energy'],
      )!,
      rightEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right_energy'],
      )!,
      silenceRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}silence_ratio'],
      )!,
      bothSidesDetected: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}both_sides_detected'],
      )!,
      audioSourceUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_source_used'],
      ),
      errorReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_reason'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      processingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processing_status'],
      )!,
      transcript: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transcript'],
      ),
      summaryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CallsTable createAlias(String alias) {
    return $CallsTable(attachedDatabase, alias);
  }
}

class Call extends DataClass implements Insertable<Call> {
  final String id;
  final String? phoneNumber;
  final String? contactName;
  final String direction;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationMs;
  final String? recordingPath;
  final String recordingStatus;
  final String recordingStrategy;
  final String? compatibilityColor;
  final int fileSizeBytes;
  final int channelCount;
  final int sampleRate;
  final double leftEnergy;
  final double rightEnergy;
  final double silenceRatio;
  final bool bothSidesDetected;
  final String? audioSourceUsed;
  final String? errorReason;
  final String? notes;
  final String processingStatus;
  final String? transcript;
  final String? summaryJson;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Call({
    required this.id,
    this.phoneNumber,
    this.contactName,
    required this.direction,
    required this.startedAt,
    this.endedAt,
    required this.durationMs,
    this.recordingPath,
    required this.recordingStatus,
    required this.recordingStrategy,
    this.compatibilityColor,
    required this.fileSizeBytes,
    required this.channelCount,
    required this.sampleRate,
    required this.leftEnergy,
    required this.rightEnergy,
    required this.silenceRatio,
    required this.bothSidesDetected,
    this.audioSourceUsed,
    this.errorReason,
    this.notes,
    required this.processingStatus,
    this.transcript,
    this.summaryJson,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || contactName != null) {
      map['contact_name'] = Variable<String>(contactName);
    }
    map['direction'] = Variable<String>(direction);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || recordingPath != null) {
      map['recording_path'] = Variable<String>(recordingPath);
    }
    map['recording_status'] = Variable<String>(recordingStatus);
    map['recording_strategy'] = Variable<String>(recordingStrategy);
    if (!nullToAbsent || compatibilityColor != null) {
      map['compatibility_color'] = Variable<String>(compatibilityColor);
    }
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    map['channel_count'] = Variable<int>(channelCount);
    map['sample_rate'] = Variable<int>(sampleRate);
    map['left_energy'] = Variable<double>(leftEnergy);
    map['right_energy'] = Variable<double>(rightEnergy);
    map['silence_ratio'] = Variable<double>(silenceRatio);
    map['both_sides_detected'] = Variable<bool>(bothSidesDetected);
    if (!nullToAbsent || audioSourceUsed != null) {
      map['audio_source_used'] = Variable<String>(audioSourceUsed);
    }
    if (!nullToAbsent || errorReason != null) {
      map['error_reason'] = Variable<String>(errorReason);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['processing_status'] = Variable<String>(processingStatus);
    if (!nullToAbsent || transcript != null) {
      map['transcript'] = Variable<String>(transcript);
    }
    if (!nullToAbsent || summaryJson != null) {
      map['summary_json'] = Variable<String>(summaryJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CallsCompanion toCompanion(bool nullToAbsent) {
    return CallsCompanion(
      id: Value(id),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      contactName: contactName == null && nullToAbsent
          ? const Value.absent()
          : Value(contactName),
      direction: Value(direction),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      durationMs: Value(durationMs),
      recordingPath: recordingPath == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingPath),
      recordingStatus: Value(recordingStatus),
      recordingStrategy: Value(recordingStrategy),
      compatibilityColor: compatibilityColor == null && nullToAbsent
          ? const Value.absent()
          : Value(compatibilityColor),
      fileSizeBytes: Value(fileSizeBytes),
      channelCount: Value(channelCount),
      sampleRate: Value(sampleRate),
      leftEnergy: Value(leftEnergy),
      rightEnergy: Value(rightEnergy),
      silenceRatio: Value(silenceRatio),
      bothSidesDetected: Value(bothSidesDetected),
      audioSourceUsed: audioSourceUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(audioSourceUsed),
      errorReason: errorReason == null && nullToAbsent
          ? const Value.absent()
          : Value(errorReason),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      processingStatus: Value(processingStatus),
      transcript: transcript == null && nullToAbsent
          ? const Value.absent()
          : Value(transcript),
      summaryJson: summaryJson == null && nullToAbsent
          ? const Value.absent()
          : Value(summaryJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Call.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Call(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      contactName: serializer.fromJson<String?>(json['contactName']),
      direction: serializer.fromJson<String>(json['direction']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      recordingPath: serializer.fromJson<String?>(json['recordingPath']),
      recordingStatus: serializer.fromJson<String>(json['recordingStatus']),
      recordingStrategy: serializer.fromJson<String>(json['recordingStrategy']),
      compatibilityColor: serializer.fromJson<String?>(
        json['compatibilityColor'],
      ),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      channelCount: serializer.fromJson<int>(json['channelCount']),
      sampleRate: serializer.fromJson<int>(json['sampleRate']),
      leftEnergy: serializer.fromJson<double>(json['leftEnergy']),
      rightEnergy: serializer.fromJson<double>(json['rightEnergy']),
      silenceRatio: serializer.fromJson<double>(json['silenceRatio']),
      bothSidesDetected: serializer.fromJson<bool>(json['bothSidesDetected']),
      audioSourceUsed: serializer.fromJson<String?>(json['audioSourceUsed']),
      errorReason: serializer.fromJson<String?>(json['errorReason']),
      notes: serializer.fromJson<String?>(json['notes']),
      processingStatus: serializer.fromJson<String>(json['processingStatus']),
      transcript: serializer.fromJson<String?>(json['transcript']),
      summaryJson: serializer.fromJson<String?>(json['summaryJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'contactName': serializer.toJson<String?>(contactName),
      'direction': serializer.toJson<String>(direction),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'recordingPath': serializer.toJson<String?>(recordingPath),
      'recordingStatus': serializer.toJson<String>(recordingStatus),
      'recordingStrategy': serializer.toJson<String>(recordingStrategy),
      'compatibilityColor': serializer.toJson<String?>(compatibilityColor),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'channelCount': serializer.toJson<int>(channelCount),
      'sampleRate': serializer.toJson<int>(sampleRate),
      'leftEnergy': serializer.toJson<double>(leftEnergy),
      'rightEnergy': serializer.toJson<double>(rightEnergy),
      'silenceRatio': serializer.toJson<double>(silenceRatio),
      'bothSidesDetected': serializer.toJson<bool>(bothSidesDetected),
      'audioSourceUsed': serializer.toJson<String?>(audioSourceUsed),
      'errorReason': serializer.toJson<String?>(errorReason),
      'notes': serializer.toJson<String?>(notes),
      'processingStatus': serializer.toJson<String>(processingStatus),
      'transcript': serializer.toJson<String?>(transcript),
      'summaryJson': serializer.toJson<String?>(summaryJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Call copyWith({
    String? id,
    Value<String?> phoneNumber = const Value.absent(),
    Value<String?> contactName = const Value.absent(),
    String? direction,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? durationMs,
    Value<String?> recordingPath = const Value.absent(),
    String? recordingStatus,
    String? recordingStrategy,
    Value<String?> compatibilityColor = const Value.absent(),
    int? fileSizeBytes,
    int? channelCount,
    int? sampleRate,
    double? leftEnergy,
    double? rightEnergy,
    double? silenceRatio,
    bool? bothSidesDetected,
    Value<String?> audioSourceUsed = const Value.absent(),
    Value<String?> errorReason = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? processingStatus,
    Value<String?> transcript = const Value.absent(),
    Value<String?> summaryJson = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Call(
    id: id ?? this.id,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    contactName: contactName.present ? contactName.value : this.contactName,
    direction: direction ?? this.direction,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    durationMs: durationMs ?? this.durationMs,
    recordingPath: recordingPath.present
        ? recordingPath.value
        : this.recordingPath,
    recordingStatus: recordingStatus ?? this.recordingStatus,
    recordingStrategy: recordingStrategy ?? this.recordingStrategy,
    compatibilityColor: compatibilityColor.present
        ? compatibilityColor.value
        : this.compatibilityColor,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    channelCount: channelCount ?? this.channelCount,
    sampleRate: sampleRate ?? this.sampleRate,
    leftEnergy: leftEnergy ?? this.leftEnergy,
    rightEnergy: rightEnergy ?? this.rightEnergy,
    silenceRatio: silenceRatio ?? this.silenceRatio,
    bothSidesDetected: bothSidesDetected ?? this.bothSidesDetected,
    audioSourceUsed: audioSourceUsed.present
        ? audioSourceUsed.value
        : this.audioSourceUsed,
    errorReason: errorReason.present ? errorReason.value : this.errorReason,
    notes: notes.present ? notes.value : this.notes,
    processingStatus: processingStatus ?? this.processingStatus,
    transcript: transcript.present ? transcript.value : this.transcript,
    summaryJson: summaryJson.present ? summaryJson.value : this.summaryJson,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Call copyWithCompanion(CallsCompanion data) {
    return Call(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      contactName: data.contactName.present
          ? data.contactName.value
          : this.contactName,
      direction: data.direction.present ? data.direction.value : this.direction,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      recordingPath: data.recordingPath.present
          ? data.recordingPath.value
          : this.recordingPath,
      recordingStatus: data.recordingStatus.present
          ? data.recordingStatus.value
          : this.recordingStatus,
      recordingStrategy: data.recordingStrategy.present
          ? data.recordingStrategy.value
          : this.recordingStrategy,
      compatibilityColor: data.compatibilityColor.present
          ? data.compatibilityColor.value
          : this.compatibilityColor,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      channelCount: data.channelCount.present
          ? data.channelCount.value
          : this.channelCount,
      sampleRate: data.sampleRate.present
          ? data.sampleRate.value
          : this.sampleRate,
      leftEnergy: data.leftEnergy.present
          ? data.leftEnergy.value
          : this.leftEnergy,
      rightEnergy: data.rightEnergy.present
          ? data.rightEnergy.value
          : this.rightEnergy,
      silenceRatio: data.silenceRatio.present
          ? data.silenceRatio.value
          : this.silenceRatio,
      bothSidesDetected: data.bothSidesDetected.present
          ? data.bothSidesDetected.value
          : this.bothSidesDetected,
      audioSourceUsed: data.audioSourceUsed.present
          ? data.audioSourceUsed.value
          : this.audioSourceUsed,
      errorReason: data.errorReason.present
          ? data.errorReason.value
          : this.errorReason,
      notes: data.notes.present ? data.notes.value : this.notes,
      processingStatus: data.processingStatus.present
          ? data.processingStatus.value
          : this.processingStatus,
      transcript: data.transcript.present
          ? data.transcript.value
          : this.transcript,
      summaryJson: data.summaryJson.present
          ? data.summaryJson.value
          : this.summaryJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Call(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('contactName: $contactName, ')
          ..write('direction: $direction, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('recordingPath: $recordingPath, ')
          ..write('recordingStatus: $recordingStatus, ')
          ..write('recordingStrategy: $recordingStrategy, ')
          ..write('compatibilityColor: $compatibilityColor, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('channelCount: $channelCount, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('leftEnergy: $leftEnergy, ')
          ..write('rightEnergy: $rightEnergy, ')
          ..write('silenceRatio: $silenceRatio, ')
          ..write('bothSidesDetected: $bothSidesDetected, ')
          ..write('audioSourceUsed: $audioSourceUsed, ')
          ..write('errorReason: $errorReason, ')
          ..write('notes: $notes, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('transcript: $transcript, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    phoneNumber,
    contactName,
    direction,
    startedAt,
    endedAt,
    durationMs,
    recordingPath,
    recordingStatus,
    recordingStrategy,
    compatibilityColor,
    fileSizeBytes,
    channelCount,
    sampleRate,
    leftEnergy,
    rightEnergy,
    silenceRatio,
    bothSidesDetected,
    audioSourceUsed,
    errorReason,
    notes,
    processingStatus,
    transcript,
    summaryJson,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Call &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.contactName == this.contactName &&
          other.direction == this.direction &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMs == this.durationMs &&
          other.recordingPath == this.recordingPath &&
          other.recordingStatus == this.recordingStatus &&
          other.recordingStrategy == this.recordingStrategy &&
          other.compatibilityColor == this.compatibilityColor &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.channelCount == this.channelCount &&
          other.sampleRate == this.sampleRate &&
          other.leftEnergy == this.leftEnergy &&
          other.rightEnergy == this.rightEnergy &&
          other.silenceRatio == this.silenceRatio &&
          other.bothSidesDetected == this.bothSidesDetected &&
          other.audioSourceUsed == this.audioSourceUsed &&
          other.errorReason == this.errorReason &&
          other.notes == this.notes &&
          other.processingStatus == this.processingStatus &&
          other.transcript == this.transcript &&
          other.summaryJson == this.summaryJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CallsCompanion extends UpdateCompanion<Call> {
  final Value<String> id;
  final Value<String?> phoneNumber;
  final Value<String?> contactName;
  final Value<String> direction;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> durationMs;
  final Value<String?> recordingPath;
  final Value<String> recordingStatus;
  final Value<String> recordingStrategy;
  final Value<String?> compatibilityColor;
  final Value<int> fileSizeBytes;
  final Value<int> channelCount;
  final Value<int> sampleRate;
  final Value<double> leftEnergy;
  final Value<double> rightEnergy;
  final Value<double> silenceRatio;
  final Value<bool> bothSidesDetected;
  final Value<String?> audioSourceUsed;
  final Value<String?> errorReason;
  final Value<String?> notes;
  final Value<String> processingStatus;
  final Value<String?> transcript;
  final Value<String?> summaryJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CallsCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.contactName = const Value.absent(),
    this.direction = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.recordingPath = const Value.absent(),
    this.recordingStatus = const Value.absent(),
    this.recordingStrategy = const Value.absent(),
    this.compatibilityColor = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.channelCount = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.leftEnergy = const Value.absent(),
    this.rightEnergy = const Value.absent(),
    this.silenceRatio = const Value.absent(),
    this.bothSidesDetected = const Value.absent(),
    this.audioSourceUsed = const Value.absent(),
    this.errorReason = const Value.absent(),
    this.notes = const Value.absent(),
    this.processingStatus = const Value.absent(),
    this.transcript = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CallsCompanion.insert({
    required String id,
    this.phoneNumber = const Value.absent(),
    this.contactName = const Value.absent(),
    required String direction,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.recordingPath = const Value.absent(),
    this.recordingStatus = const Value.absent(),
    this.recordingStrategy = const Value.absent(),
    this.compatibilityColor = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.channelCount = const Value.absent(),
    this.sampleRate = const Value.absent(),
    this.leftEnergy = const Value.absent(),
    this.rightEnergy = const Value.absent(),
    this.silenceRatio = const Value.absent(),
    this.bothSidesDetected = const Value.absent(),
    this.audioSourceUsed = const Value.absent(),
    this.errorReason = const Value.absent(),
    this.notes = const Value.absent(),
    this.processingStatus = const Value.absent(),
    this.transcript = const Value.absent(),
    this.summaryJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       direction = Value(direction),
       startedAt = Value(startedAt);
  static Insertable<Call> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? contactName,
    Expression<String>? direction,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMs,
    Expression<String>? recordingPath,
    Expression<String>? recordingStatus,
    Expression<String>? recordingStrategy,
    Expression<String>? compatibilityColor,
    Expression<int>? fileSizeBytes,
    Expression<int>? channelCount,
    Expression<int>? sampleRate,
    Expression<double>? leftEnergy,
    Expression<double>? rightEnergy,
    Expression<double>? silenceRatio,
    Expression<bool>? bothSidesDetected,
    Expression<String>? audioSourceUsed,
    Expression<String>? errorReason,
    Expression<String>? notes,
    Expression<String>? processingStatus,
    Expression<String>? transcript,
    Expression<String>? summaryJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (contactName != null) 'contact_name': contactName,
      if (direction != null) 'direction': direction,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (recordingPath != null) 'recording_path': recordingPath,
      if (recordingStatus != null) 'recording_status': recordingStatus,
      if (recordingStrategy != null) 'recording_strategy': recordingStrategy,
      if (compatibilityColor != null) 'compatibility_color': compatibilityColor,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (channelCount != null) 'channel_count': channelCount,
      if (sampleRate != null) 'sample_rate': sampleRate,
      if (leftEnergy != null) 'left_energy': leftEnergy,
      if (rightEnergy != null) 'right_energy': rightEnergy,
      if (silenceRatio != null) 'silence_ratio': silenceRatio,
      if (bothSidesDetected != null) 'both_sides_detected': bothSidesDetected,
      if (audioSourceUsed != null) 'audio_source_used': audioSourceUsed,
      if (errorReason != null) 'error_reason': errorReason,
      if (notes != null) 'notes': notes,
      if (processingStatus != null) 'processing_status': processingStatus,
      if (transcript != null) 'transcript': transcript,
      if (summaryJson != null) 'summary_json': summaryJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CallsCompanion copyWith({
    Value<String>? id,
    Value<String?>? phoneNumber,
    Value<String?>? contactName,
    Value<String>? direction,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? durationMs,
    Value<String?>? recordingPath,
    Value<String>? recordingStatus,
    Value<String>? recordingStrategy,
    Value<String?>? compatibilityColor,
    Value<int>? fileSizeBytes,
    Value<int>? channelCount,
    Value<int>? sampleRate,
    Value<double>? leftEnergy,
    Value<double>? rightEnergy,
    Value<double>? silenceRatio,
    Value<bool>? bothSidesDetected,
    Value<String?>? audioSourceUsed,
    Value<String?>? errorReason,
    Value<String?>? notes,
    Value<String>? processingStatus,
    Value<String?>? transcript,
    Value<String?>? summaryJson,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CallsCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contactName: contactName ?? this.contactName,
      direction: direction ?? this.direction,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMs: durationMs ?? this.durationMs,
      recordingPath: recordingPath ?? this.recordingPath,
      recordingStatus: recordingStatus ?? this.recordingStatus,
      recordingStrategy: recordingStrategy ?? this.recordingStrategy,
      compatibilityColor: compatibilityColor ?? this.compatibilityColor,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      channelCount: channelCount ?? this.channelCount,
      sampleRate: sampleRate ?? this.sampleRate,
      leftEnergy: leftEnergy ?? this.leftEnergy,
      rightEnergy: rightEnergy ?? this.rightEnergy,
      silenceRatio: silenceRatio ?? this.silenceRatio,
      bothSidesDetected: bothSidesDetected ?? this.bothSidesDetected,
      audioSourceUsed: audioSourceUsed ?? this.audioSourceUsed,
      errorReason: errorReason ?? this.errorReason,
      notes: notes ?? this.notes,
      processingStatus: processingStatus ?? this.processingStatus,
      transcript: transcript ?? this.transcript,
      summaryJson: summaryJson ?? this.summaryJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (contactName.present) {
      map['contact_name'] = Variable<String>(contactName.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (recordingPath.present) {
      map['recording_path'] = Variable<String>(recordingPath.value);
    }
    if (recordingStatus.present) {
      map['recording_status'] = Variable<String>(recordingStatus.value);
    }
    if (recordingStrategy.present) {
      map['recording_strategy'] = Variable<String>(recordingStrategy.value);
    }
    if (compatibilityColor.present) {
      map['compatibility_color'] = Variable<String>(compatibilityColor.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (channelCount.present) {
      map['channel_count'] = Variable<int>(channelCount.value);
    }
    if (sampleRate.present) {
      map['sample_rate'] = Variable<int>(sampleRate.value);
    }
    if (leftEnergy.present) {
      map['left_energy'] = Variable<double>(leftEnergy.value);
    }
    if (rightEnergy.present) {
      map['right_energy'] = Variable<double>(rightEnergy.value);
    }
    if (silenceRatio.present) {
      map['silence_ratio'] = Variable<double>(silenceRatio.value);
    }
    if (bothSidesDetected.present) {
      map['both_sides_detected'] = Variable<bool>(bothSidesDetected.value);
    }
    if (audioSourceUsed.present) {
      map['audio_source_used'] = Variable<String>(audioSourceUsed.value);
    }
    if (errorReason.present) {
      map['error_reason'] = Variable<String>(errorReason.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (processingStatus.present) {
      map['processing_status'] = Variable<String>(processingStatus.value);
    }
    if (transcript.present) {
      map['transcript'] = Variable<String>(transcript.value);
    }
    if (summaryJson.present) {
      map['summary_json'] = Variable<String>(summaryJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CallsCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('contactName: $contactName, ')
          ..write('direction: $direction, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('recordingPath: $recordingPath, ')
          ..write('recordingStatus: $recordingStatus, ')
          ..write('recordingStrategy: $recordingStrategy, ')
          ..write('compatibilityColor: $compatibilityColor, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('channelCount: $channelCount, ')
          ..write('sampleRate: $sampleRate, ')
          ..write('leftEnergy: $leftEnergy, ')
          ..write('rightEnergy: $rightEnergy, ')
          ..write('silenceRatio: $silenceRatio, ')
          ..write('bothSidesDetected: $bothSidesDetected, ')
          ..write('audioSourceUsed: $audioSourceUsed, ')
          ..write('errorReason: $errorReason, ')
          ..write('notes: $notes, ')
          ..write('processingStatus: $processingStatus, ')
          ..write('transcript: $transcript, ')
          ..write('summaryJson: $summaryJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CallsTable calls = $CallsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [calls];
}

typedef $$CallsTableCreateCompanionBuilder = CallsCompanion Function({
  required String id,
  Value<String?> phoneNumber,
  Value<String?> contactName,
  required String direction,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  Value<int> durationMs,
  Value<String?> recordingPath,
  Value<String> recordingStatus,
  Value<String> recordingStrategy,
  Value<String?> compatibilityColor,
  Value<int> fileSizeBytes,
  Value<int> channelCount,
  Value<int> sampleRate,
  Value<double> leftEnergy,
  Value<double> rightEnergy,
  Value<double> silenceRatio,
  Value<bool> bothSidesDetected,
  Value<String?> audioSourceUsed,
  Value<String?> errorReason,
  Value<String?> notes,
  Value<String> processingStatus,
  Value<String?> transcript,
  Value<String?> summaryJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$CallsTableUpdateCompanionBuilder = CallsCompanion Function({
  Value<String> id,
  Value<String?> phoneNumber,
  Value<String?> contactName,
  Value<String> direction,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> durationMs,
  Value<String?> recordingPath,
  Value<String> recordingStatus,
  Value<String> recordingStrategy,
  Value<String?> compatibilityColor,
  Value<int> fileSizeBytes,
  Value<int> channelCount,
  Value<int> sampleRate,
  Value<double> leftEnergy,
  Value<double> rightEnergy,
  Value<double> silenceRatio,
  Value<bool> bothSidesDetected,
  Value<String?> audioSourceUsed,
  Value<String?> errorReason,
  Value<String?> notes,
  Value<String> processingStatus,
  Value<String?> transcript,
  Value<String?> summaryJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CallsTableFilterComposer extends Composer<_$AppDatabase, $CallsTable> {
  $$CallsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordingPath => $composableBuilder(
    column: $table.recordingPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordingStatus => $composableBuilder(
    column: $table.recordingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordingStrategy => $composableBuilder(
    column: $table.recordingStrategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get compatibilityColor => $composableBuilder(
    column: $table.compatibilityColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get channelCount => $composableBuilder(
    column: $table.channelCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leftEnergy => $composableBuilder(
    column: $table.leftEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rightEnergy => $composableBuilder(
    column: $table.rightEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get silenceRatio => $composableBuilder(
    column: $table.silenceRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bothSidesDetected => $composableBuilder(
    column: $table.bothSidesDetected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioSourceUsed => $composableBuilder(
    column: $table.audioSourceUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorReason => $composableBuilder(
    column: $table.errorReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CallsTableOrderingComposer
    extends Composer<_$AppDatabase, $CallsTable> {
  $$CallsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordingPath => $composableBuilder(
    column: $table.recordingPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordingStatus => $composableBuilder(
    column: $table.recordingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordingStrategy => $composableBuilder(
    column: $table.recordingStrategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get compatibilityColor => $composableBuilder(
    column: $table.compatibilityColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get channelCount => $composableBuilder(
    column: $table.channelCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leftEnergy => $composableBuilder(
    column: $table.leftEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rightEnergy => $composableBuilder(
    column: $table.rightEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get silenceRatio => $composableBuilder(
    column: $table.silenceRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bothSidesDetected => $composableBuilder(
    column: $table.bothSidesDetected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioSourceUsed => $composableBuilder(
    column: $table.audioSourceUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorReason => $composableBuilder(
    column: $table.errorReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CallsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CallsTable> {
  $$CallsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contactName => $composableBuilder(
    column: $table.contactName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordingPath => $composableBuilder(
    column: $table.recordingPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordingStatus => $composableBuilder(
    column: $table.recordingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordingStrategy => $composableBuilder(
    column: $table.recordingStrategy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get compatibilityColor => $composableBuilder(
    column: $table.compatibilityColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get channelCount => $composableBuilder(
    column: $table.channelCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sampleRate => $composableBuilder(
    column: $table.sampleRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leftEnergy => $composableBuilder(
    column: $table.leftEnergy,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rightEnergy => $composableBuilder(
    column: $table.rightEnergy,
    builder: (column) => column,
  );

  GeneratedColumn<double> get silenceRatio => $composableBuilder(
    column: $table.silenceRatio,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get bothSidesDetected => $composableBuilder(
    column: $table.bothSidesDetected,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioSourceUsed => $composableBuilder(
    column: $table.audioSourceUsed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorReason => $composableBuilder(
    column: $table.errorReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get processingStatus => $composableBuilder(
    column: $table.processingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transcript => $composableBuilder(
    column: $table.transcript,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summaryJson => $composableBuilder(
    column: $table.summaryJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CallsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CallsTable,
          Call,
          $$CallsTableFilterComposer,
          $$CallsTableOrderingComposer,
          $$CallsTableAnnotationComposer,
          $$CallsTableCreateCompanionBuilder,
          $$CallsTableUpdateCompanionBuilder,
          (Call, BaseReferences<_$AppDatabase, $CallsTable, Call>),
          Call,
          PrefetchHooks Function()
        > {
  $$CallsTableTableManager(_$AppDatabase db, $CallsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CallsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CallsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CallsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> recordingPath = const Value.absent(),
                Value<String> recordingStatus = const Value.absent(),
                Value<String> recordingStrategy = const Value.absent(),
                Value<String?> compatibilityColor = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int> channelCount = const Value.absent(),
                Value<int> sampleRate = const Value.absent(),
                Value<double> leftEnergy = const Value.absent(),
                Value<double> rightEnergy = const Value.absent(),
                Value<double> silenceRatio = const Value.absent(),
                Value<bool> bothSidesDetected = const Value.absent(),
                Value<String?> audioSourceUsed = const Value.absent(),
                Value<String?> errorReason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> processingStatus = const Value.absent(),
                Value<String?> transcript = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallsCompanion(
                id: id,
                phoneNumber: phoneNumber,
                contactName: contactName,
                direction: direction,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                recordingPath: recordingPath,
                recordingStatus: recordingStatus,
                recordingStrategy: recordingStrategy,
                compatibilityColor: compatibilityColor,
                fileSizeBytes: fileSizeBytes,
                channelCount: channelCount,
                sampleRate: sampleRate,
                leftEnergy: leftEnergy,
                rightEnergy: rightEnergy,
                silenceRatio: silenceRatio,
                bothSidesDetected: bothSidesDetected,
                audioSourceUsed: audioSourceUsed,
                errorReason: errorReason,
                notes: notes,
                processingStatus: processingStatus,
                transcript: transcript,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> phoneNumber = const Value.absent(),
                Value<String?> contactName = const Value.absent(),
                required String direction,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> recordingPath = const Value.absent(),
                Value<String> recordingStatus = const Value.absent(),
                Value<String> recordingStrategy = const Value.absent(),
                Value<String?> compatibilityColor = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int> channelCount = const Value.absent(),
                Value<int> sampleRate = const Value.absent(),
                Value<double> leftEnergy = const Value.absent(),
                Value<double> rightEnergy = const Value.absent(),
                Value<double> silenceRatio = const Value.absent(),
                Value<bool> bothSidesDetected = const Value.absent(),
                Value<String?> audioSourceUsed = const Value.absent(),
                Value<String?> errorReason = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> processingStatus = const Value.absent(),
                Value<String?> transcript = const Value.absent(),
                Value<String?> summaryJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CallsCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                contactName: contactName,
                direction: direction,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                recordingPath: recordingPath,
                recordingStatus: recordingStatus,
                recordingStrategy: recordingStrategy,
                compatibilityColor: compatibilityColor,
                fileSizeBytes: fileSizeBytes,
                channelCount: channelCount,
                sampleRate: sampleRate,
                leftEnergy: leftEnergy,
                rightEnergy: rightEnergy,
                silenceRatio: silenceRatio,
                bothSidesDetected: bothSidesDetected,
                audioSourceUsed: audioSourceUsed,
                errorReason: errorReason,
                notes: notes,
                processingStatus: processingStatus,
                transcript: transcript,
                summaryJson: summaryJson,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CallsTable, Call>(table),
                  BaseReferences<_$AppDatabase, $CallsTable, Call>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CallsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CallsTable,
      Call,
      $$CallsTableFilterComposer,
      $$CallsTableOrderingComposer,
      $$CallsTableAnnotationComposer,
      $$CallsTableCreateCompanionBuilder,
      $$CallsTableUpdateCompanionBuilder,
      (Call, BaseReferences<_$AppDatabase, $CallsTable, Call>),
      Call,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CallsTableTableManager get calls =>
      $$CallsTableTableManager(_db, _db.calls);
}
