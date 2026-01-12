import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

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
  /// 배너 정보 조회
  static Future<List<BannerInfo>> getBannerInfo() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/banner');

      if (response.statusCode == 200) {
        final List<BannerInfo> bannerInfo =
            (response.data as List).map((e) => BannerInfo.fromJson(e)).toList();
        return bannerInfo;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('배너 조회 실패', e, stackTrace);
      throw UnknownException.fromError(e);
    }
  }
}
