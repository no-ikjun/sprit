import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sprit/core/util/logger.dart';

/// API 클라이언트 싱글톤
/// BuildContext 의존성을 제거하고 Dio 인스턴스를 재사용합니다
class ApiClient {
  ApiClient._();

  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  Dio? _dio;
  final _storage = const FlutterSecureStorage();

  /// Dio 인스턴스 가져오기 (초기화 필요 시 자동 초기화)
  Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  /// 새로운 Dio 인스턴스 생성
  Dio _createDio({String? contentType}) {
    final dio = Dio();
    dio.options.baseUrl = _getBaseUrl();
    dio.options.contentType = contentType ?? 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final accessToken = await _storage.read(key: 'access_token');
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          AppLogger.networkError(
            error.requestOptions.path,
            error,
            error.stackTrace,
          );

          // 401, 403 에러 시 토큰 삭제 (네비게이션은 상위에서 처리)
          if (error.response?.statusCode == 401 ||
              error.response?.statusCode == 403) {
            await _storage.deleteAll();
            AppLogger.warning('Authentication failed, tokens cleared');
          }

          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  /// Base URL 가져오기
  String _getBaseUrl() {
    if (kReleaseMode) {
      return dotenv.env['BASE_URL'] ?? '';
    } else {
      return Platform.isAndroid
          ? dotenv.env['DEBUG_BASE_URL_ANDROID'] ?? ''
          : dotenv.env['DEBUG_BASE_URL'] ?? '';
    }
  }

  /// multipart/form-data용 Dio 인스턴스 가져오기
  Dio getMultipartDio() {
    return _createDio(contentType: 'multipart/form-data');
  }

  /// Dio 인스턴스 재생성 (토큰 변경 등 필요 시)
  void reset() {
    _dio = null;
  }

  /// 토큰 삭제
  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  /// 액세스 토큰 가져오기
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
}
