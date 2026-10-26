import 'dart:developer' as dev;

class AppLogger {
  static void debug(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.DEBUG');
  }

  static void info(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.INFO');
  }

  static void warning(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.WARN');
  }

  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  ]) {
    dev.log(
      message,
      name: tag ?? 'DigitalBalance.ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
