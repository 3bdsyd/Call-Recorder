import 'package:call_recorder/core/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('wire values round-trip', () {
    for (final s in RecordingStatus.values) {
      expect(RecordingStatus.fromWire(s.wire), s);
    }
    for (final s in RecordingStrategy.values) {
      expect(RecordingStrategy.fromWire(s.wire), s);
    }
    for (final d in CallDirection.values) {
      expect(CallDirection.fromWire(d.wire), d);
    }
  });

  test('status maps to compatibility colour', () {
    expect(CompatColor.fromStatus(RecordingStatus.successBothSides), CompatColor.green);
    expect(CompatColor.fromStatus(RecordingStatus.partialOneSide), CompatColor.yellow);
    expect(CompatColor.fromStatus(RecordingStatus.recordingFailed), CompatColor.red);
    expect(CompatColor.fromStatus(RecordingStatus.silent), CompatColor.gray);
  });
}
