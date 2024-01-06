import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class BannerInfo {
  final String bannerUuid;
  final String backgroundColor;
  final String title;
  final String content;
  final String iconUrl;
  final String createdAt;
  final String clickUrl;
  const BannerInfo({
    required this.bannerUuid,
    required this.backgroundColor,
    required this.title,
    required this.content,
    required this.iconUrl,
    required this.createdAt,
    required this.clickUrl,
  });
  BannerInfo.fromJson(Map<String, dynamic> json)
      : bannerUuid = json['banner_uuid'],
        backgroundColor = json['background_color'],
        title = json['title'],
        content = json['content'],
        iconUrl = json['icon_url'],
        createdAt = json['created_at'],
        clickUrl = json['click_url'];
  Map<String, dynamic> toJson() => {
        'banner_uuid': bannerUuid,
        'background_color': backgroundColor,
        'title': title,
        'content': content,
        'icon_url': iconUrl,
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
