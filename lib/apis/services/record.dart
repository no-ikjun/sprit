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
  final int totalTime;
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
    required this.totalTime,
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
      totalTime: json['total_time'] as int,
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
      'total_time': totalTime,
      'start': start,
      'end': end,
      'goal_achieved': goalAchieved,
      'created_at': createdAt,
    };
  }
}

class MonthlyRecordInfo {
  final int presentMonth;
  final int pastMonth;
  const MonthlyRecordInfo({
    required this.presentMonth,
    required this.pastMonth,
  });

  factory MonthlyRecordInfo.fromJson(Map<String, dynamic> json) {
    return MonthlyRecordInfo(
      presentMonth: json['present_month'] as int,
      pastMonth: json['past_month'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'present_month': presentMonth,
      'past_month': pastMonth,
    };
  }
}

class BookRecordHistory {
  final String bookUuid;
  final bool goalAchieved;
  final int totalTime;
  const BookRecordHistory({
    required this.bookUuid,
    required this.goalAchieved,
    required this.totalTime,
  });

  factory BookRecordHistory.fromJson(Map<String, dynamic> json) {
    return BookRecordHistory(
      bookUuid: json['book_uuid'] as String,
      goalAchieved: json['goal_achieved'] as bool,
      totalTime: json['total_time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book_uuid': bookUuid,
      'is_achieved': goalAchieved,
      'total_time': totalTime,
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
      totalTime: 0,
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
    int totalTime,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/record/stop',
        queryParameters: {
          'record_uuid': recordUuid,
          'page_end': pageEnd,
          'total_time': totalTime,
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
      totalTime: 0,
      start: '',
      end: '',
      goalAchieved: false,
      createdAt: '',
    );
    try {
      final response = await dio.get('/record/notended');
      debugPrint('notended: ${response.data}');
      if (response.statusCode == 200) {
        if (response.data == null || response.data == '') {
          return recordInfo;
        }
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
    bool isBeforeRecord,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/record/last-page',
        queryParameters: {
          'book_uuid': bookUuid,
          'is_before_record': isBeforeRecord,
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

  static Future<List<int>> getRecordCount(
    BuildContext context,
    int count,
  ) async {
    List<int> result = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/record/record-count',
        queryParameters: {
          'count': count,
        },
      );
      if (response.statusCode == 200) {
        result = response.data.map<int>((e) => e as int).toList();
      } else {
        debugPrint('기록 수 불러오기 실패');
      }
    } catch (e) {
      debugPrint('기록 수 불러오기 실패: $e');
    }
    return result;
  }

  static Future<int> getDailyTotalTime(
    BuildContext context,
    int backDate,
  ) async {
    final dio = await authDio(context);
    DateTime now = DateTime.now();
    DateTime targetDate = now.subtract(Duration(days: backDate));
    try {
      final response = await dio.get(
        '/record/daily-record',
        queryParameters: {
          'year': targetDate.year,
          'month': targetDate.month,
          'date': targetDate.day,
        },
      );
      if (response.statusCode == 200) {
        return int.parse(response.data);
      } else {
        debugPrint('일일 총 시간 불러오기 실패');
        return 0;
      }
    } catch (e) {
      debugPrint('일일 총 시간 불러오기 실패: $e');
      return 0;
    }
  }

  static Future<MonthlyRecordInfo> getMonthlyRecord(
    BuildContext context,
    int year,
    int month,
    String kind,
  ) async {
    MonthlyRecordInfo result = const MonthlyRecordInfo(
      presentMonth: 0,
      pastMonth: 0,
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/record/monthly-count',
        queryParameters: {
          'year': year,
          'month': month,
          'kind': kind,
        },
      );
      if (response.statusCode == 200) {
        result = MonthlyRecordInfo.fromJson(response.data);
      } else {
        debugPrint('월별 기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('월별 기록 불러오기 실패: $e');
    }
    return result;
  }

  static Future<List<List<BookRecordHistory>>> getWeeklyRecord(
    BuildContext context,
    int backWeek, //몇주 전인지
    int weekday, //툐요일 6, 일요일 7, 월요일 1
  ) async {
    List<List<BookRecordHistory>> result = [];
    int count = weekday == 7 ? 1 : weekday + 1;
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/record/weekly-record',
        queryParameters: {
          'back_week': backWeek,
          'count': count,
          'today': DateTime.now().weekday % 7,
        },
      );
      if (response.statusCode == 200) {
        for (var records in response.data) {
          List<BookRecordHistory> bookRecords = [];
          for (var record in records) {
            bookRecords.add(BookRecordHistory.fromJson(record));
          }
          result.add(bookRecords);
        }
      } else {
        debugPrint('주별 기록 불러오기 실패');
      }
    } catch (e) {
      debugPrint('주별 기록 불러오기 실패: $e');
    }
    return result;
  }
}
