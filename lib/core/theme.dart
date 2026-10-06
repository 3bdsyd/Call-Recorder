import 'package:flutter/material.dart';

import 'enums.dart';

/// Arabic-first visual theme. Clean and modern, but deliberately not over-polished — recording
/// reliability comes first.
class AppTheme {
  static const seed = Color(0xFF1E6F6A);

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(centerTitle: true, backgroundColor: scheme.surface),
      cardTheme: const CardThemeData(margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
      listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4)),
    );
  }
}

/// UI colour for a compatibility verdict.
Color compatColorValue(CompatColor c, ColorScheme scheme) => switch (c) {
      CompatColor.green => const Color(0xFF2E7D32),
      CompatColor.yellow => const Color(0xFFE6A700),
      CompatColor.red => scheme.error,
      CompatColor.gray => scheme.outline,
    };

/// Icon + colour for a recording status, used throughout the call list.
({IconData icon, Color color, String label}) statusBadge(RecordingStatus s, ColorScheme scheme) {
  switch (s) {
    case RecordingStatus.successBothSides:
      return (icon: Icons.verified, color: const Color(0xFF2E7D32), label: '✓ ${s.arabic}');
    case RecordingStatus.partialOneSide:
      return (icon: Icons.warning_amber_rounded, color: const Color(0xFFE6A700), label: '⚠ ${s.arabic}');
    case RecordingStatus.silent:
      return (icon: Icons.volume_off, color: scheme.outline, label: s.arabic);
    case RecordingStatus.invalidFile:
    case RecordingStatus.recordingFailed:
      return (icon: Icons.error_outline, color: scheme.error, label: s.arabic);
    case RecordingStatus.unknown:
      return (icon: Icons.help_outline, color: scheme.outline, label: s.arabic);
  }
}
