import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class NoticeInfo {
  final String noticeUuid;
  final String title;
  final String body;
  final String type;
  final String createdAt;
  const NoticeInfo({
    required this.noticeUuid,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
  });

  factory NoticeInfo.fromJson(Map<String, dynamic> json) {
    return NoticeInfo(
      noticeUuid: json['notice_uuid'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notice_uuid': noticeUuid,
      'title': title,
      'body': body,
      'type': type,
      'created_at': createdAt,
    };
  }
}

class NoticeService {
  /// 공지사항 목록 조회
  static Future<List<NoticeInfo>> getNoticeList() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/notice/all');

      if (response.statusCode == 200) {
        final List<NoticeInfo> noticeList = [];
        for (final json in response.data) {
          noticeList.add(NoticeInfo.fromJson(json));
        }
        return noticeList;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('공지사항 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 공지사항 상세 조회
  static Future<NoticeInfo> getNoticeInfo(String noticeUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/notice/uuid',
        queryParameters: {
          'notice_uuid': noticeUuid,
        },
      );

      if (response.statusCode == 200) {
        return NoticeInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('공지사항 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 최신 공지사항 UUID 조회
  static Future<String> getlatestNoticeUuid() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/notice/latest');

      if (response.statusCode == 200) {
        return response.data as String;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('최신 공지사항 조회 실패', e, stackTrace);
      rethrow;
    }
  }
}
