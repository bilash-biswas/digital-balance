import 'package:intl/intl.dart';

class Formatters {
  static String formatDurationMinutes(int totalMinutes) {
    if (totalMinutes <= 0) return '0m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${minutes}m';
    }
  }

  static String formatWellbeingDuration(int totalMinutes) {
    if (totalMinutes <= 0) return '0 minutes';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) {
      return '$hours hr, $minutes min';
    } else if (hours > 0) {
      return '$hours hr';
    } else if (minutes == 1) {
      return '1 minute';
    } else {
      return '$minutes minutes';
    }
  }

  static String formatDurationMs(int totalMs) {
    final minutes = (totalMs / (1000 * 60)).round();
    return formatDurationMinutes(minutes);
  }

  static String formatMinuteOfDay(int minuteOfDay, {bool is24Hour = false}) {
    if (minuteOfDay < 0 || minuteOfDay >= 1440) return '--:--';
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    final time = DateTime(2026, 1, 1, hour, minute);
    return is24Hour
        ? DateFormat('HH:mm').format(time)
        : DateFormat('h:mm a').format(time);
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatMonthDay(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}
