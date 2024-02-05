import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class BannerInfo {
  final String bannerUuid;
  final String bannerUrl;
  final String createdAt;
  final String clickUrl;
  const BannerInfo({
    required this.bannerUuid,
    required this.bannerUrl,
    required this.createdAt,
    required this.clickUrl,
  });
  BannerInfo.fromJson(Map<String, dynamic> json)
      : bannerUuid = json['banner_uuid'],
        bannerUrl = json['banner_url'],
        createdAt = json['created_at'],
        clickUrl = json['click_url'];
  Map<String, dynamic> toJson() => {
        'banner_uuid': bannerUuid,
        'banner_url': bannerUrl,
        'created_at': createdAt,
        'click_url': clickUrl,
      };
}

class BannerInfoService {
  static Future<List<BannerInfo>> getBannerInfo(BuildContext context) async {
    List<BannerInfo> bannerInfo = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/banner');
      if (response.statusCode == 200) {
        bannerInfo =
            (response.data as List).map((e) => BannerInfo.fromJson(e)).toList();
      } else {
        debugPrint('배너 조회 실패');
      }
    } catch (e) {
      debugPrint('배너 조회 실패 $e');
    }
    return bannerInfo;
  }
}
