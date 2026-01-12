import 'package:flutter/material.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

/// 중앙화된 에러 처리
class ErrorHandler {
  ErrorHandler._();

  /// 에러를 사용자 친화적인 메시지로 변환
  static String getErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    } else if (error is Exception) {
      return '예기치 않은 오류가 발생했습니다: ${error.toString()}';
    } else {
      return '알 수 없는 오류가 발생했습니다.';
    }
  }

  /// 에러 로깅
  static void logError(Object error, [StackTrace? stackTrace]) {
    if (error is ApiException) {
      AppLogger.error(
        'API Error: ${error.message}',
        error.originalError,
        stackTrace,
      );
    } else {
      AppLogger.error('Error occurred', error, stackTrace);
    }
  }

  /// 에러를 SnackBar로 표시
  static void showErrorSnackBar(BuildContext context, Object error) {
    final message = getErrorMessage(error);
    logError(error);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 13),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 성공 메시지를 SnackBar로 표시
  static void showSuccessSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 13),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
