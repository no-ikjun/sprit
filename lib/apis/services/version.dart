import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class VersionInfo {
  final String versionUuid;
  final String versionNumber;
  final String buildNumber;
  final bool updateRequired;
  final String description;
  final String createdAt;
  const VersionInfo({
    required this.versionUuid,
    required this.versionNumber,
    required this.buildNumber,
    required this.updateRequired,
    required this.description,
    required this.createdAt,
  });

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      versionUuid: json['version_uuid'],
      versionNumber: json['version_number'],
      buildNumber: json['build_number'],
      updateRequired: json['update_required'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version_uuid': versionUuid,
      'version_number': versionNumber,
      'build_number': buildNumber,
      'update_required': updateRequired,
      'description': description,
      'created_at': createdAt,
    };
  }
}

class VersionService {
  /// 최신 버전 정보 조회
  static Future<VersionInfo> getLatestVersion() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/version');
      
      if (response.statusCode == 200) {
        return VersionInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('버전 정보 불러오기 실패', e, stackTrace);
      throw UnknownException.fromError(e);
    }
  }
}
