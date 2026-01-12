import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class TimeAgreeInfo {
  final String agreeUuid;
  final bool agree01;
  final int time01;
  final bool agree02;
  const TimeAgreeInfo({
    required this.agreeUuid,
    required this.agree01,
    required this.time01,
    required this.agree02,
  });
  TimeAgreeInfo.fromJson(Map<String, dynamic> json)
      : agreeUuid = json['agree_uuid'],
        agree01 = json['agree_01'],
        time01 = json['time_01'],
        agree02 = json['agree_02'];
  Map<String, dynamic> toJson() => {
        'agree_uuid': agreeUuid,
        'agree_01': agree01,
        'time_01': time01,
        'agree_02': agree02,
      };
}

class RemindAgreeInfo {
  final String agreeUuid;
  final bool agree01;
  final int time01;
  const RemindAgreeInfo({
    required this.agreeUuid,
    required this.agree01,
    required this.time01,
  });
  RemindAgreeInfo.fromJson(Map<String, dynamic> json)
      : agreeUuid = json['agree_uuid'],
        agree01 = json['agree_01'],
        time01 = json['time_01'];
  Map<String, dynamic> toJson() => {
        'agree_uuid': agreeUuid,
        'agree_01': agree01,
        'time_01': time01,
      };
}

class QuestAgreeInfo {
  final String agreeUuid;
  final bool agree01;
  final bool agree02;
  final bool agree03;
  const QuestAgreeInfo({
    required this.agreeUuid,
    required this.agree01,
    required this.agree02,
    required this.agree03,
  });
  QuestAgreeInfo.fromJson(Map<String, dynamic> json)
      : agreeUuid = json['agree_uuid'],
        agree01 = json['agree_01'],
        agree02 = json['agree_02'],
        agree03 = json['agree_03'];
  Map<String, dynamic> toJson() => {
        'agree_uuid': agreeUuid,
        'agree_01': agree01,
        'agree_02': agree02,
        'agree_03': agree03,
      };
}

class NotificationService {
  /// FCM 토큰 등록
  static Future<void> registerFcmToken(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/notification/register',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('FCM 토큰 등록 실패', e, stackTrace);
      rethrow;
    }
  }

  /// FCM 토큰 삭제
  static Future<void> deleteFcmToken(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      await dio.delete('/notification/delete', queryParameters: {
        'fcm_token': fcmToken,
      });
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('FCM 토큰 삭제 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 시간 알림 동의 정보 조회
  static Future<TimeAgreeInfo> getTimeAgreeInfo(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/notification/agree/time',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        return TimeAgreeInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('시간 알림 동의 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 리마인드 알림 동의 정보 조회
  static Future<RemindAgreeInfo> getRemindAgreeInfo(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/notification/agree/remind',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        return RemindAgreeInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('리마인드 알림 동의 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 퀘스트 알림 동의 정보 조회
  static Future<QuestAgreeInfo> getQuestAgreeInfo(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/notification/agree/quest',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        return QuestAgreeInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 알림 동의 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 시간 알림 동의 정보 수정
  static Future<void> updateTimeAgree(
    String fcmToken,
    bool agree01,
    int time01,
    bool agree02,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/notification/agree/time',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'time_01': time01,
          'agree_02': agree02,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('시간 알림 동의 정보 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 시간만 수정
  static Future<void> updateOnlyTime(String fcmToken, int time) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/notification/agree/time/only',
        queryParameters: {
          'fcm_token': fcmToken,
          'time_01': time,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('시간 알림 동의 정보 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 리마인드 알림 동의 정보 수정
  static Future<void> updateRemindAgree(
    String fcmToken,
    bool agree01,
    int time01,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/notification/agree/remind',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'time_01': time01,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('리마인드 알림 동의 정보 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 퀘스트 알림 동의 정보 수정
  static Future<void> updateQuestAgree(
    String fcmToken,
    bool agree01,
    bool agree02,
    bool agree03,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/notification/agree/quest',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'agree_02': agree02,
          'agree_03': agree03,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 알림 동의 정보 수정 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 마케팅 알림 동의 정보 조회
  static Future<bool> getMarketingAgree(String fcmToken) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/notification/agree/marketing',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        return response.data.toString() == 'true';
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('마케팅 알림 동의 정보 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 마케팅 알림 동의 정보 수정
  static Future<void> updateMarketingAgree(
    String fcmToken,
    bool marketingAgree,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.patch(
        '/notification/agree/marketing',
        queryParameters: {
          'fcm_token': fcmToken,
          'marketing_agree': marketingAgree,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('마케팅 알림 동의 정보 수정 실패', e, stackTrace);
      rethrow;
    }
  }
}
