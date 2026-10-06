import 'package:flutter/services.dart';
import '../core/enums.dart';
import 'native_models.dart';

/// Clean abstraction over the native recording layer. Nothing else in the Dart app touches a
/// [MethodChannel]/[EventChannel] directly — UI and repositories depend on this interface.
abstract class CallRecorderPlatform {
  Future<DeviceInfoData> getDeviceInfo();
  Future<List<RecordingStrategy>> getAvailableStrategies();

  Future<bool> isAutoRecord();
  Future<void> setAutoRecord(bool enabled);

  Future<RecordingStrategy?> getPreferredStrategy();
  Future<void> setPreferredStrategy(RecordingStrategy? strategy);

  /// Start a manual/test recording (optionally forcing a strategy).
  Future<void> manualStart({RecordingStrategy? strategy});
  Future<void> manualStop();

  Future<void> saveCompatResult(CompatColor color, RecordingStrategy strategy, RecordingStatus status);

  /// Ask Shizuku for permission; resolves true when granted.
  Future<bool> requestShizukuPermission();

  Future<Map<dynamic, dynamic>> getNativeDiagnostics();

  Stream<NativeCallEvent> callEvents();
  Stream<NativeLogEvent> logEvents();
}

class MethodChannelCallRecorder implements CallRecorderPlatform {
  static const _methods = MethodChannel('call_recorder/methods');
  static const _events = EventChannel('call_recorder/events');
  static const _logs = EventChannel('call_recorder/logs');

  Stream<NativeCallEvent>? _callStream;
  Stream<NativeLogEvent>? _logStream;

  @override
  Future<DeviceInfoData> getDeviceInfo() async {
    final m = await _methods.invokeMethod<Map<dynamic, dynamic>>('getDeviceInfo');
    return DeviceInfoData.fromMap(m ?? const {});
  }

  @override
  Future<List<RecordingStrategy>> getAvailableStrategies() async {
    final list = await _methods.invokeMethod<List<dynamic>>('getAvailableStrategies');
    return (list ?? const []).map((e) => RecordingStrategy.fromWire(e.toString())).toList();
  }

  @override
  Future<bool> isAutoRecord() async =>
      await _methods.invokeMethod<bool>('isAutoRecord') ?? false;

  @override
  Future<void> setAutoRecord(bool enabled) =>
      _methods.invokeMethod('setAutoRecord', {'enabled': enabled});

  @override
  Future<RecordingStrategy?> getPreferredStrategy() async {
    final v = await _methods.invokeMethod<String>('getPreferredStrategy');
    return v == null ? null : RecordingStrategy.fromWire(v);
  }

  @override
  Future<void> setPreferredStrategy(RecordingStrategy? strategy) =>
      _methods.invokeMethod('setPreferredStrategy', {'strategy': strategy?.wire});

  @override
  Future<void> manualStart({RecordingStrategy? strategy}) =>
      _methods.invokeMethod('manualStart', {'strategy': strategy?.wire});

  @override
  Future<void> manualStop() => _methods.invokeMethod('manualStop');

  @override
  Future<void> saveCompatResult(CompatColor color, RecordingStrategy strategy, RecordingStatus status) =>
      _methods.invokeMethod('saveCompatResult', {
        'color': color.wire,
        'strategy': strategy.wire,
        'status': status.wire,
      });

  @override
  Future<bool> requestShizukuPermission() async =>
      await _methods.invokeMethod<bool>('requestShizukuPermission') ?? false;

  @override
  Future<Map<dynamic, dynamic>> getNativeDiagnostics() async =>
      await _methods.invokeMethod<Map<dynamic, dynamic>>('getNativeDiagnostics') ?? const {};

  @override
  Stream<NativeCallEvent> callEvents() {
    return _callStream ??= _events
        .receiveBroadcastStream()
        .map((e) => NativeCallEvent.fromMap(e as Map<dynamic, dynamic>));
  }

  @override
  Stream<NativeLogEvent> logEvents() {
    return _logStream ??= _logs
        .receiveBroadcastStream()
        .map((e) => NativeLogEvent.fromMap(e as Map<dynamic, dynamic>));
  }
}
