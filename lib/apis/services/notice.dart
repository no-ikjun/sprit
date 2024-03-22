import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

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
  static Future<List<NoticeInfo>> getNoticeList(BuildContext context) async {
    final dio = await authDio(context);
    List<NoticeInfo> noticeList = [];
    try {
      final response = await dio.get('/notice/all');
      if (response.statusCode == 200) {
        for (final json in response.data) {
          noticeList.add(NoticeInfo.fromJson(json));
        }
      } else {
        debugPrint('공지사항 조회 실패');
      }
    } catch (e) {
      debugPrint('공지사항 조회 실패 $e');
    }
    return noticeList;
  }

  static Future<NoticeInfo> getNoticeInfo(
    BuildContext context,
    String noticeUuid,
  ) async {
    final dio = await authDio(context);
    NoticeInfo noticeInfo = const NoticeInfo(
      noticeUuid: '',
      title: '',
      body: '',
      type: '',
      createdAt: '',
    );
    try {
      final response = await dio.get(
        '/notice/uuid',
        queryParameters: {
          'notice_uuid': noticeUuid,
        },
      );
      if (response.statusCode == 200) {
        noticeInfo = NoticeInfo.fromJson(response.data);
      } else {
        debugPrint('공지사항 조회 실패');
      }
    } catch (e) {
      debugPrint('공지사항 조회 실패 $e');
    }
    return noticeInfo;
  }
}
