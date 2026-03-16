import 'package:flutter/foundation.dart';

/// Logger utilitaire pour le debug.
class AppLogger {
  AppLogger._();

  static void debug(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[DEBUG]';
      // ignore: avoid_print
      print('$prefix $message');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ERROR] $message');
      if (error != null) {
        // ignore: avoid_print
        print('[ERROR] $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('[STACK] $stackTrace');
      }
    }
  }

  static void info(String message, [String? tag]) {
    if (kDebugMode) {
      final prefix = tag != null ? '[$tag]' : '[INFO]';
      // ignore: avoid_print
      print('$prefix $message');
    }
  }
}
