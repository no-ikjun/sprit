import 'package:flutter/cupertino.dart';
import 'package:sprit/apis/auth_dio.dart';

class TimeAgreeInfo {
  final String agreeUuid;
  final bool agree01;
  final int time01;
  const TimeAgreeInfo({
    required this.agreeUuid,
    required this.agree01,
    required this.time01,
  });
  TimeAgreeInfo.fromJson(Map<String, dynamic> json)
      : agreeUuid = json['agree_uuid'],
        agree01 = json['agree_01'],
        time01 = json['time_01'];
  Map<String, dynamic> toJson() => {
        'agree_uuid': agreeUuid,
        'agree_01': agree01,
        'time_01': time01,
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
  static Future<void> registerFcmToken(
    BuildContext context,
    String fcmToken,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/notification/register',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );
      if (response.statusCode == 201) {
      } else {
        debugPrint('FCM 토큰 등록 실패');
      }
    } catch (e) {
      debugPrint('FCM 토큰 등록 실패 $e');
    }
  }

  static Future<TimeAgreeInfo> getTimeAgreeInfo(
    BuildContext context,
    String fcmToken,
  ) async {
    TimeAgreeInfo timeAgreeInfo = const TimeAgreeInfo(
      agreeUuid: '',
      agree01: false,
      time01: 0,
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/notification/agree/time',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );
      if (response.statusCode == 200) {
        timeAgreeInfo = TimeAgreeInfo.fromJson(response.data);
      } else {
        debugPrint('시간 알림 동의 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('시간 알림 동의 정보 조회 실패 $e');
    }
    return timeAgreeInfo;
  }

  static Future<RemindAgreeInfo> getRemindAgreeInfo(
    BuildContext context,
    String fcmToken,
  ) async {
    RemindAgreeInfo remindAgreeInfo = const RemindAgreeInfo(
      agreeUuid: '',
      agree01: false,
      time01: 0,
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/notification/agree/remind',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );
      if (response.statusCode == 200) {
        remindAgreeInfo = RemindAgreeInfo.fromJson(response.data);
      } else {
        debugPrint('리마인드 알림 동의 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('리마인드 알림 동의 정보 조회 실패 $e');
    }
    return remindAgreeInfo;
  }

  static Future<QuestAgreeInfo> getQuestAgreeInfo(
    BuildContext context,
    String fcmToken,
  ) async {
    QuestAgreeInfo questAgreeInfo = const QuestAgreeInfo(
      agreeUuid: '',
      agree01: false,
      agree02: false,
      agree03: false,
    );
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/notification/agree/quest',
        queryParameters: {
          'fcm_token': fcmToken,
        },
      );

      if (response.statusCode == 200) {
        questAgreeInfo = QuestAgreeInfo.fromJson(response.data);
      } else {
        debugPrint('퀘스트 알림 동의 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 알림 동의 정보 조회 실패 $e');
    }
    return questAgreeInfo;
  }

  static Future<bool> updateTimeAgree(
    BuildContext context,
    String fcmToken,
    bool agree01,
    int time01,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/notification/agree/time',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'time_01': time01,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('시간 알림 동의 정보 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('시간 알림 동의 정보 수정 실패 $e');
      return false;
    }
  }

  static Future<bool> updateRemindAgree(
    BuildContext context,
    String fcmToken,
    bool agree01,
    int time01,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/notification/agree/remind',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'time_01': time01,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('리마인드 알림 동의 정보 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('리마인드 알림 동의 정보 수정 실패 $e');
      return false;
    }
  }

  static Future<bool> updateQuestAgree(
    BuildContext context,
    String fcmToken,
    bool agree01,
    bool agree02,
    bool agree03,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/notification/agree/quest',
        queryParameters: {
          'fcm_token': fcmToken,
          'agree_01': agree01,
          'agree_02': agree02,
          'agree_03': agree03,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        debugPrint('퀘스트 알림 동의 정보 수정 실패');
        return false;
      }
    } catch (e) {
      debugPrint('퀘스트 알림 동의 정보 수정 실패 $e');
      return false;
    }
  }
}
