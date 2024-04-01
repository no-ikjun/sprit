import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

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
  static Future<VersionInfo> getLatestVersion(BuildContext context) async {
    final dio = await authDio(context);
    VersionInfo versionInfo = const VersionInfo(
      versionUuid: '',
      versionNumber: '',
      buildNumber: '',
      updateRequired: false,
      description: '',
      createdAt: '',
    );
    try {
      final response = await dio.get('/version');
      if (response.statusCode == 200) {
        versionInfo = VersionInfo.fromJson(response.data);
        return versionInfo;
      } else {
        debugPrint('버전 정보 불러오기 실패');
        return versionInfo;
      }
    } catch (e) {
      debugPrint('버전 정보 불러오기 실패 $e');
      return versionInfo;
    }
  }
}
