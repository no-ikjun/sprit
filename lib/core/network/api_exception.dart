import 'package:dio/dio.dart';
import 'package:sprit/core/util/logger.dart';

/// API 관련 예외의 기본 클래스
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ApiException(
    this.message, {
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => message;
}

/// 네트워크 연결 오류
class NetworkException extends ApiException {
  const NetworkException(super.message,
      {super.statusCode, super.originalError});

  factory NetworkException.fromDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('요청 시간이 초과되었습니다.');
    } else if (error.type == DioExceptionType.connectionError) {
      return const NetworkException('인터넷 연결을 확인해주세요.');
    }
    return NetworkException(
      '네트워크 오류가 발생했습니다.',
      originalError: error,
    );
  }
}

/// 인증 오류 (401, 400)
class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message,
      {super.statusCode, super.originalError});

  factory UnauthorizedException.fromResponse(Response? response) {
    return UnauthorizedException(
      '인증이 필요합니다. 다시 로그인해주세요.',
      statusCode: response?.statusCode,
      originalError: response?.data,
    );
  }
}

/// 서버 오류 (500대)
class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode, super.originalError});

  factory ServerException.fromResponse(Response? response) {
    return ServerException(
      '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: response?.statusCode,
      originalError: response?.data,
    );
  }
}

/// 클라이언트 오류 (400대)
class ClientException extends ApiException {
  const ClientException(super.message, {super.statusCode, super.originalError});

  factory ClientException.fromResponse(Response? response) {
    final message = response?.data?['message'] as String? ?? '요청을 처리할 수 없습니다.';
    return ClientException(
      message,
      statusCode: response?.statusCode,
      originalError: response?.data,
    );
  }
}

/// 알 수 없는 오류
class UnknownException extends ApiException {
  const UnknownException(super.message,
      {super.statusCode, super.originalError});

  factory UnknownException.fromError(Object error) {
    AppLogger.error('Unknown error occurred', error);
    return UnknownException(
      '알 수 없는 오류가 발생했습니다.',
      originalError: error,
    );
  }
}

/// DioException을 ApiException으로 변환
ApiException handleDioException(DioException error) {
  AppLogger.networkError(
    error.requestOptions.path,
    error,
    error.stackTrace,
  );

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return NetworkException.fromDioError(error);

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return UnauthorizedException.fromResponse(error.response);
      } else if (statusCode != null && statusCode >= 500) {
        return ServerException.fromResponse(error.response);
      } else if (statusCode != null && statusCode >= 400) {
        return ClientException.fromResponse(error.response);
      }
      return UnknownException.fromError(error);

    default:
      return NetworkException.fromDioError(error);
  }
}
