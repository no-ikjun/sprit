import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

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
      'goal_achieved': goalAchieved,
      'total_time': totalTime,
    };
  }
}

class RecordService {
  /// 새 기록 생성
  static Future<String> setNewRecord(
    String bookUuid,
    String goalType,
    int goalScale,
    int startPage,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
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
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 생성 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 기록 삭제
  static Future<void> deleteRecord(String recordUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.delete(
        '/record',
        queryParameters: {
          'record_uuid': recordUuid,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 삭제 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 기록 UUID로 조회
  static Future<RecordInfo> getRecordByRecordUuid(String recordUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/record',
        queryParameters: {
          'record_uuid': recordUuid,
        },
      );

      if (response.statusCode == 200) {
        return RecordInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 기록 종료
  static Future<void> stopRecord(
    String recordUuid,
    int pageEnd,
    int totalTime,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/record/stop',
        queryParameters: {
          'record_uuid': recordUuid,
          'page_end': pageEnd,
          'total_time': totalTime,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 종료 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 목표 달성 여부 업데이트
  static Future<void> updateGoalAchieved(
    String recordUuid,
    bool goalAchieved,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/record/goal-achieved',
        queryParameters: {
          'record_uuid': recordUuid,
          'goal_achieved': goalAchieved,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('목표 달성 여부 업데이트 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 마지막 페이지 업데이트
  static Future<void> updatePageEnd(
    String recordUuid,
    int pageEnd,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/record/page-end',
        queryParameters: {
          'record_uuid': recordUuid,
          'page_end': pageEnd,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('마지막 페이지 업데이트 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 진행 중인 기록 조회
  static Future<RecordInfo> getNotEndedRecord() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/record/notended');

      if (response.statusCode == 200) {
        if (response.data == null || response.data == '') {
          return const RecordInfo(
            recordUuid: '',
            bookUuid: '',
            userUuid: '',
            goalType: '',
            goalScale: 0,
            pageStart: 0,
            pageEnd: 0,
            totalTime: 0,
            start: '',
            end: null,
            goalAchieved: false,
            createdAt: '',
          );
        }
        return RecordInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('진행 중인 기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 모든 기록 조회
  static Future<List<RecordInfo>> getAllRecord() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/record/all');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((record) => RecordInfo.fromJson(record))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('모든 기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 종료된 기록 조회
  static Future<List<RecordInfo>> getEndedRecord() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/record/ended');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((record) => RecordInfo.fromJson(record))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('지난 기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 마지막 페이지 조회
  static Future<int> getLastPage(
    String bookUuid,
    bool isBeforeRecord,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/record/last-page',
        queryParameters: {
          'book_uuid': bookUuid,
          'is_before_record': isBeforeRecord,
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.data.toString());
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('마지막 페이지 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 기록 수 조회
  static Future<List<int>> getRecordCount(int count) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/record/record-count',
        queryParameters: {
          'count': count,
        },
      );

      if (response.statusCode == 200) {
        return (response.data as List).map<int>((e) => e as int).toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 수 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 일일 총 시간 조회
  static Future<int> getDailyTotalTime(int backDate) async {
    try {
      final dio = ApiClient.instance.dio;
      final now = DateTime.now();
      final targetDate = now.subtract(Duration(days: backDate));
      final response = await dio.get(
        '/record/daily-record',
        queryParameters: {
          'year': targetDate.year,
          'month': targetDate.month,
          'date': targetDate.day,
        },
      );

      if (response.statusCode == 200) {
        return int.parse(response.data.toString());
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('일일 총 시간 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 월별 기록 조회
  static Future<MonthlyRecordInfo> getMonthlyRecord(
    int year,
    int month,
    String kind,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/record/monthly-count',
        queryParameters: {
          'year': year,
          'month': month,
          'kind': kind,
        },
      );

      if (response.statusCode == 200) {
        return MonthlyRecordInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('월별 기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 주별 기록 조회
  static Future<List<List<BookRecordHistory>>> getWeeklyRecord(
    int backWeek, // 몇주 전인지
    int weekday, // 토요일 6, 일요일 7, 월요일 1
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final count = weekday == 7 ? 1 : weekday + 1;
      final response = await dio.get(
        '/record/weekly-record',
        queryParameters: {
          'back_week': backWeek,
          'count': count,
          'today': DateTime.now().weekday % 7,
        },
      );

      if (response.statusCode == 200) {
        AppLogger.info('response.data: ${response.data}');
        return (response.data as List).map<List<BookRecordHistory>>((records) {
          return (records as List)
              .map((record) => BookRecordHistory.fromJson(record))
              .toList();
        }).toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('주별 기록 불러오기 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 읽기 완료 후 기록 추가
  static Future<String> addRecordAfterRead(
    String bookUuid,
    String goalType,
    int readTime,
    int pageStart,
    int pageEnd,
    DateTime startTime,
    DateTime endTime,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/record/add',
        data: {
          'book_uuid': bookUuid,
          'goal_type': goalType,
          'read_time': readTime,
          'page_start': pageStart,
          'page_end': pageEnd,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
        },
      );

      if (response.statusCode == 201) {
        return response.data as String;
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('기록 생성 실패', e, stackTrace);
      rethrow;
    }
  }
}
