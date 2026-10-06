import '../core/enums.dart';

/// Diagnostics for one recording attempt, as produced by the native [AudioValidator].
class RecordingDiagnosticsData {
  const RecordingDiagnosticsData({
    required this.strategy,
    required this.status,
    required this.outputPath,
    required this.fileSizeBytes,
    required this.durationMs,
    required this.channelCount,
    required this.sampleRate,
    required this.leftEnergy,
    required this.rightEnergy,
    required this.silenceRatio,
    required this.bothSidesDetected,
    required this.audioSourceUsed,
    required this.errorReason,
    required this.notes,
  });

  final RecordingStrategy strategy;
  final RecordingStatus status;
  final String? outputPath;
  final int fileSizeBytes;
  final int durationMs;
  final int channelCount;
  final int sampleRate;
  final double leftEnergy;
  final double rightEnergy;
  final double silenceRatio;
  final bool bothSidesDetected;
  final String? audioSourceUsed;
  final String? errorReason;
  final List<String> notes;

  factory RecordingDiagnosticsData.fromMap(Map<dynamic, dynamic> m) => RecordingDiagnosticsData(
        strategy: RecordingStrategy.fromWire(m['strategy'] as String?),
        status: RecordingStatus.fromWire(m['status'] as String?),
        outputPath: m['outputPath'] as String?,
        fileSizeBytes: (m['fileSizeBytes'] as num?)?.toInt() ?? 0,
        durationMs: (m['durationMs'] as num?)?.toInt() ?? 0,
        channelCount: (m['channelCount'] as num?)?.toInt() ?? 0,
        sampleRate: (m['sampleRate'] as num?)?.toInt() ?? 0,
        leftEnergy: (m['leftEnergy'] as num?)?.toDouble() ?? 0,
        rightEnergy: (m['rightEnergy'] as num?)?.toDouble() ?? 0,
        silenceRatio: (m['silenceRatio'] as num?)?.toDouble() ?? 0,
        bothSidesDetected: m['bothSidesDetected'] as bool? ?? false,
        audioSourceUsed: m['audioSourceUsed'] as String?,
        errorReason: m['errorReason'] as String?,
        notes: (m['notes'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );
}

/// Device + capability snapshot from the native [CompatibilityProbe].
class DeviceInfoData {
  const DeviceInfoData({
    required this.manufacturer,
    required this.brand,
    required this.model,
    required this.androidRelease,
    required this.sdkInt,
    required this.fingerprint,
    required this.availableStrategies,
    required this.shizukuInstalled,
    required this.shizukuRunning,
    required this.shizukuAuthorized,
    required this.savedColor,
  });

  final String manufacturer;
  final String brand;
  final String model;
  final String androidRelease;
  final int sdkInt;
  final String fingerprint;
  final List<RecordingStrategy> availableStrategies;
  final bool shizukuInstalled;
  final bool shizukuRunning;
  final bool shizukuAuthorized;
  final CompatColor? savedColor;

  factory DeviceInfoData.fromMap(Map<dynamic, dynamic> m) {
    final saved = m['savedResult'] as Map?;
    return DeviceInfoData(
      manufacturer: m['manufacturer']?.toString() ?? '',
      brand: m['brand']?.toString() ?? '',
      model: m['model']?.toString() ?? '',
      androidRelease: m['androidRelease']?.toString() ?? '',
      sdkInt: (m['sdkInt'] as num?)?.toInt() ?? 0,
      fingerprint: m['fingerprint']?.toString() ?? '',
      availableStrategies: (m['availableStrategies'] as List?)
              ?.map((e) => RecordingStrategy.fromWire(e.toString()))
              .toList() ??
          const [],
      shizukuInstalled: m['shizukuInstalled'] as bool? ?? false,
      shizukuRunning: m['shizukuRunning'] as bool? ?? false,
      shizukuAuthorized: m['shizukuAuthorized'] as bool? ?? false,
      savedColor: saved == null ? null : CompatColor.fromWire(saved['color'] as String?),
    );
  }
}

/// A call/recording lifecycle event streamed from native.
class NativeCallEvent {
  const NativeCallEvent({
    required this.type,
    required this.callId,
    required this.direction,
    required this.phoneNumber,
    required this.contactName,
    required this.startedAtMillis,
    required this.endedAtMillis,
    required this.durationMs,
    required this.diagnostics,
  });

  final String type; // CALL_STARTED | CALL_ENDED | RECORDING_COMPLETED
  final String? callId;
  final CallDirection direction;
  final String? phoneNumber;
  final String? contactName;
  final int? startedAtMillis;
  final int? endedAtMillis;
  final int durationMs;
  final RecordingDiagnosticsData? diagnostics;

  factory NativeCallEvent.fromMap(Map<dynamic, dynamic> m) => NativeCallEvent(
        type: m['type']?.toString() ?? 'UNKNOWN',
        callId: m['id'] as String?,
        direction: CallDirection.fromWire(m['direction'] as String?),
        phoneNumber: m['phoneNumber'] as String?,
        contactName: m['contactName'] as String?,
        startedAtMillis: (m['startedAtMillis'] as num?)?.toInt(),
        endedAtMillis: (m['endedAtMillis'] as num?)?.toInt(),
        durationMs: (m['durationMs'] as num?)?.toInt() ?? 0,
        diagnostics: (m['diagnostics'] as Map?) == null
            ? null
            : RecordingDiagnosticsData.fromMap(m['diagnostics'] as Map),
      );
}

/// A structured native log line for the debug screen.
class NativeLogEvent {
  const NativeLogEvent({required this.ts, required this.event, required this.level, required this.raw});
  final int ts;
  final String event;
  final String level;
  final Map<dynamic, dynamic> raw;

  factory NativeLogEvent.fromMap(Map<dynamic, dynamic> m) => NativeLogEvent(
        ts: (m['ts'] as num?)?.toInt() ?? 0,
        event: m['event']?.toString() ?? '',
        level: m['level']?.toString() ?? 'info',
        raw: m,
      );
}
