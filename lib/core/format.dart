import 'package:intl/intl.dart';

/// Arabic-friendly formatting helpers.
class Fmt {
  static final _time = DateFormat('HH:mm', 'ar');
  static final _dayMonth = DateFormat('d MMMM', 'ar');
  static final _full = DateFormat('EEEE d MMMM yyyy – HH:mm', 'ar');

  /// "اليوم 18:42" / "أمس 09:15" / "3 مايو 14:00".
  static String relativeDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    final diffDays = today.difference(that).inDays;
    final time = _time.format(dt);
    if (diffDays == 0) return 'اليوم $time';
    if (diffDays == 1) return 'أمس $time';
    return '${_dayMonth.format(dt)} $time';
  }

  static String fullDateTime(DateTime dt) => _full.format(dt);

  /// "04:31" from milliseconds.
  static String duration(int ms) {
    final totalSeconds = ms ~/ 1000;
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    final h = totalSeconds ~/ 3600;
    if (h > 0) {
      final mm = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
      return '$h:$mm:$s';
    }
    return '$m:$s';
  }

  static String fileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var i = 0;
    while (size >= 1024 && i < units.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(size < 10 && i > 0 ? 1 : 0)} ${units[i]}';
  }
}
