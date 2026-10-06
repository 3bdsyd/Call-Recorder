/// Shared vocabulary between Dart and the native layer. The `wire` strings must match the Kotlin
/// enums exactly.
library;

enum CallDirection {
  incoming('incoming'),
  outgoing('outgoing'),
  unknown('unknown');

  const CallDirection(this.wire);
  final String wire;

  static CallDirection fromWire(String? v) =>
      CallDirection.values.firstWhere((e) => e.wire == v, orElse: () => CallDirection.unknown);

  /// Arabic label.
  String get arabic => switch (this) {
        CallDirection.incoming => 'مكالمة واردة',
        CallDirection.outgoing => 'مكالمة صادرة',
        CallDirection.unknown => 'مكالمة',
      };
}

enum RecordingStatus {
  successBothSides('success_both_sides'),
  partialOneSide('partial_one_side'),
  silent('silent'),
  invalidFile('invalid_file'),
  recordingFailed('recording_failed'),
  unknown('unknown');

  const RecordingStatus(this.wire);
  final String wire;

  static RecordingStatus fromWire(String? v) =>
      RecordingStatus.values.firstWhere((e) => e.wire == v, orElse: () => RecordingStatus.unknown);

  String get arabic => switch (this) {
        RecordingStatus.successBothSides => 'تم تسجيل الطرفين',
        RecordingStatus.partialOneSide => 'تم تسجيل طرف واحد فقط',
        RecordingStatus.silent => 'التسجيل صامت',
        RecordingStatus.invalidFile => 'ملف غير صالح',
        RecordingStatus.recordingFailed => 'فشل التسجيل',
        RecordingStatus.unknown => 'غير معروف',
      };
}

enum RecordingStrategy {
  publicApi('public_api'),
  shizukuVoiceCall('shizuku_voice_call'),
  shizukuDual('shizuku_dual'),
  unsupported('unsupported');

  const RecordingStrategy(this.wire);
  final String wire;

  static RecordingStrategy fromWire(String? v) =>
      RecordingStrategy.values.firstWhere((e) => e.wire == v, orElse: () => RecordingStrategy.unsupported);

  String get arabic => switch (this) {
        RecordingStrategy.publicApi => 'الوضع القياسي (الميكروفون)',
        RecordingStrategy.shizukuVoiceCall => 'وضع Shizuku (مكالمة)',
        RecordingStrategy.shizukuDual => 'وضع Shizuku (طرفان)',
        RecordingStrategy.unsupported => 'غير مدعوم',
      };
}

/// Device-compatibility traffic light.
enum CompatColor {
  green('GREEN'),
  yellow('YELLOW'),
  red('RED'),
  gray('GRAY');

  const CompatColor(this.wire);
  final String wire;

  static CompatColor fromWire(String? v) =>
      CompatColor.values.firstWhere((e) => e.wire == v, orElse: () => CompatColor.gray);

  static CompatColor fromStatus(RecordingStatus s) => switch (s) {
        RecordingStatus.successBothSides => CompatColor.green,
        RecordingStatus.partialOneSide => CompatColor.yellow,
        RecordingStatus.recordingFailed || RecordingStatus.invalidFile => CompatColor.red,
        RecordingStatus.silent || RecordingStatus.unknown => CompatColor.gray,
      };

  String get arabicTitle => switch (this) {
        CompatColor.green => 'الجهاز يدعم تسجيل الطرفين',
        CompatColor.yellow => 'يسجّل طرفاً واحداً فقط',
        CompatColor.red => 'تسجيل المكالمات غير مدعوم',
        CompatColor.gray => 'غير معروف — يحتاج اختبار مكالمة حقيقية',
      };
}
