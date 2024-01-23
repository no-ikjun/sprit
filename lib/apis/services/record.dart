import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class RecordInfo {
  final String recordUuid;
  final String bookUuid;
  final String userUuid;
  final String goalType;
  final int goalScale;
  final String start;
  final String? end;
  final String createdAt;
  const RecordInfo({
    required this.recordUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.goalType,
    required this.goalScale,
    required this.start,
    this.end,
    required this.createdAt,
  });

  factory RecordInfo.fromJson(Map<String, dynamic> json) {
    return RecordInfo(
      recordUuid: json['record_uuid'] as String,
      bookUuid: json['book_uuid'] as String,
      userUuid: json['user_uuid'] as String,
      goalType: json['goal_type'] as String,
      goalScale: json['goal_scale'] as int,
      start: json['start'] as String,
      end: json['end'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'record_uuid': recordUuid,
      'book_uuid': bookUuid,
      'user_uuid': userUuid,
      'goal_type': goalType,
      'goal_scale': goalScale,
      'start': start,
      'end': end,
      'created_at': createdAt,
    };
  }
}

class RecordService {
  static Future<bool> setNewRecord(
    BuildContext context,
    String bookUuid,
    String goalType,
    int goalScale,
    int startPage,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/record',
        data: {
          'book_uuid': bookUuid,
          'goal_type': goalType,
          'goal_scale': goalScale,
          'start_page': startPage,
        },
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        debugPrint('기록 생성 실패');
        return false;
      }
    } catch (e) {
      debugPrint('기록 생성 실패: $e');
      return false;
    }
  }

  static Future<bool> stopRecord(
    BuildContext context,
    String recordUuid,
    int pageEnd,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/record/stop',
        data: {
          'record_uuid': recordUuid,
          'page_end': pageEnd,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('기록 종료 실패');
        return false;
      }
    } catch (e) {
      debugPrint('기록 종료 실패: $e');
      return false;
    }
  }

  static Future<RecordInfo> getNotEndedRecord(BuildContext context) async {
    final dio = await authDio(context);
    RecordInfo recordInfo = const RecordInfo(
      recordUuid: '',
      bookUuid: '',
      userUuid: '',
      goalType: '',
      goalScale: 0,
      start: '',
      end: '',
      createdAt: '',
    );
    try {
      final response = await dio.get('/record/notended');
      if (response.statusCode == 200) {
        recordInfo = RecordInfo.fromJson(response.data);
      } else {
        debugPrint('진행 중인 기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('진행 중인 기록 불러오기 실패 $e');
    }
    return recordInfo;
  }

  static Future<List<RecordInfo>> getAllRecord(BuildContext context) async {
    final dio = await authDio(context);
    List<RecordInfo> records = [];
    try {
      final response = await dio.get('/record/all');
      if (response.statusCode == 200) {
        for (var record in response.data) {
          records.add(RecordInfo.fromJson(record));
        }
      } else {
        debugPrint('모든 기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('모든 기록 불러오기 실패: $e');
    }
    return records;
  }

  static Future<List<RecordInfo>> getEndedRecord(BuildContext context) async {
    final dio = await authDio(context);
    List<RecordInfo> records = [];
    try {
      final response = await dio.get('/record/ended');
      if (response.statusCode == 200) {
        for (var record in response.data) {
          records.add(RecordInfo.fromJson(record));
        }
      } else {
        debugPrint('지난 기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('지난 기록 불러오기 실패: $e');
    }
    return records;
  }
}
