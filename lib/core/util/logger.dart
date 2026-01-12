import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// 프로덕션/개발 환경 구분된 로깅 유틸리티
class AppLogger {
  AppLogger._();

  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'SPRIT',
        level: 700, // debug level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'SPRIT',
        level: 800, // info level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'SPRIT',
        level: 900, // warning level
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // 에러는 프로덕션에서도 로깅할 수 있도록 설정 가능
    developer.log(
      message,
      name: 'SPRIT',
      level: 1000, // error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// API 관련 로깅
  static void api(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'SPRIT.API',
        level: 700,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// 네트워크 에러 로깅
  static void networkError(String endpoint, Object error,
      [StackTrace? stackTrace]) {
    developer.log(
      'Network error at $endpoint',
      name: 'SPRIT.Network',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
