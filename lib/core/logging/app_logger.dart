import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.DEBUG');
    debugPrint('[${tag ?? 'DEBUG'}] $message');
  }

  static void info(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.INFO');
    debugPrint('[${tag ?? 'INFO'}] $message');
  }

  static void warning(String message, [String? tag]) {
    dev.log(message, name: tag ?? 'DigitalBalance.WARN');
    debugPrint('[${tag ?? 'WARN'}] $message');
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
    debugPrint(
      '[${tag ?? 'ERROR'}] $message ${error != null ? ': $error' : ''}',
    );
    if (stackTrace != null) {
      debugPrint('$stackTrace');
    }
  }
}

