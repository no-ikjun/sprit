import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class RecordInfo {
  final String recordUuid;
  final String bookUuid;
  final String userUuid;
  final String goalType;
  final int goalScale;
  final int pageStart;
  final int pageEnd;
  final String start;
  final String? end;
  final bool goalAchieved;
  final String createdAt;
  const RecordInfo({
    required this.recordUuid,
    required this.bookUuid,
    required this.userUuid,
    required this.goalType,
    required this.goalScale,
    required this.pageStart,
    required this.pageEnd,
    required this.start,
    this.end,
    required this.goalAchieved,
    required this.createdAt,
  });

  factory RecordInfo.fromJson(Map<String, dynamic> json) {
    return RecordInfo(
      recordUuid: json['record_uuid'] as String,
      bookUuid: json['book_uuid'] as String,
      userUuid: json['user_uuid'] as String,
      goalType: json['goal_type'] as String,
      goalScale: json['goal_scale'] as int,
      pageStart: json['page_start'] as int,
      pageEnd: json['page_end'] as int,
      start: json['start'] as String,
      end: json['end'] as String?,
      goalAchieved: json['goal_achieved'] as bool,
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
      'page_start': pageStart,
      'page_end': pageEnd,
      'start': start,
      'end': end,
      'goal_achieved': goalAchieved,
      'created_at': createdAt,
    };
  }
}

class RecordService {
  static Future<String> setNewRecord(
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
          'page_start': startPage,
        },
      );
      if (response.statusCode == 201) {
        return response.data as String;
      } else {
        debugPrint('기록 생성 실패');
        return '';
      }
    } catch (e) {
      debugPrint('기록 생성 실패: $e');
      return '';
    }
  }

  static Future<void> deleteRecord(
    BuildContext context,
    String recordUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.delete(
        '/record',
        queryParameters: {
          'record_uuid': recordUuid,
        },
      );
      if (response.statusCode == 200) {
      } else {
        debugPrint('기록 삭제 실패');
      }
    } catch (e) {
      debugPrint('기록 삭제 실패: $e');
    }
  }

  static Future<RecordInfo> getRecordByRecordUuid(
    BuildContext context,
    String recordUuid,
  ) async {
    final dio = await authDio(context);
    RecordInfo recordInfo = const RecordInfo(
      recordUuid: '',
      bookUuid: '',
      userUuid: '',
      goalType: '',
      goalScale: 0,
      pageStart: 0,
      pageEnd: 0,
      start: '',
      end: '',
      goalAchieved: false,
      createdAt: '',
    );
    try {
      final response = await dio.get(
        '/record',
        queryParameters: {
          'record_uuid': recordUuid,
        },
      );
      if (response.statusCode == 200) {
        recordInfo = RecordInfo.fromJson(response.data);
      } else {
        debugPrint('기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('기록 불러오기 실패: $e');
    }
    return recordInfo;
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
        queryParameters: {
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

  static Future<bool> updateGoalAchieved(
    BuildContext context,
    String recordUuid,
    bool goalAchieved,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/record/goal-achieved',
        queryParameters: {
          'record_uuid': recordUuid,
          'goal_achieved': goalAchieved,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('목표 달성 여부 업데이트 실패');
        return false;
      }
    } catch (e) {
      debugPrint('목표 달성 여부 업데이트 실패: $e');
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
      pageStart: 0,
      pageEnd: 0,
      start: '',
      end: '',
      goalAchieved: false,
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

  static Future<int> getLastPage(
    BuildContext context,
    String bookUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/record/last-page',
        queryParameters: {
          'book_uuid': bookUuid,
        },
      );
      if (response.statusCode == 200) {
        return int.parse(response.data);
      } else {
        debugPrint('마지막 페이지 불러오기 실패');
        return 0;
      }
    } catch (e) {
      debugPrint('마지막 페이지 불러오기 실패: $e');
      return 0;
    }
  }
}
