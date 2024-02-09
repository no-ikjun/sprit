import 'package:flutter/cupertino.dart';
import 'package:sprit/apis/auth_dio.dart';

class QuestInfo {
  final String questUuid;
  final String title;
  final String shortDescription;
  final String longDescription;
  final String mission;
  final String iconUrl;
  final String thumbnailUrl;
  final String startDate;
  final String endDate;
  final int limit;
  final int applyCount;
  final bool isEnded;
  final String createdAt;
  const QuestInfo({
    required this.questUuid,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
    required this.mission,
    required this.iconUrl,
    required this.thumbnailUrl,
    required this.startDate,
    required this.endDate,
    required this.limit,
    required this.applyCount,
    required this.isEnded,
    required this.createdAt,
  });
  QuestInfo.fromJson(Map<String, dynamic> json)
      : questUuid = json['quest_uuid'],
        title = json['title'],
        shortDescription = json['short_description'],
        longDescription = json['long_description'],
        mission = json['mission'],
        iconUrl = json['icon_url'],
        thumbnailUrl = json['thumbnail_url'] ?? '',
        startDate = json['start_date'],
        endDate = json['end_date'],
        limit = json['limit'],
        applyCount = json['apply_count'],
        isEnded = json['is_ended'],
        createdAt = json['created_at'];
  Map<String, dynamic> toJson() => {
        'quest_uuid': questUuid,
        'title': title,
        'short_description': shortDescription,
        'long_description': longDescription,
        'mission': mission,
        'icon_url': iconUrl,
        'thumbnail_url': thumbnailUrl,
        'start_date': startDate,
        'end_date': endDate,
        'limit': limit,
        'apply_count': applyCount,
        'is_ended': isEnded,
        'created_at': createdAt,
      };
}

class QuestApplyInfo {
  final String applyUuid;
  final String questUuid;
  final String userUuid;
  final String state;
  final String phoneNumber;
  final String createdAt;
  const QuestApplyInfo({
    required this.applyUuid,
    required this.questUuid,
    required this.userUuid,
    required this.state,
    required this.phoneNumber,
    required this.createdAt,
  });
  QuestApplyInfo.fromJson(Map<String, dynamic> json)
      : applyUuid = json['apply_uuid'],
        questUuid = json['quest_uuid'],
        userUuid = json['user_uuid'],
        state = json['state'],
        phoneNumber = json['phone_number'],
        createdAt = json['created_at'];
  Map<String, dynamic> toJson() => {
        'apply_uuid': applyUuid,
        'quest_uuid': questUuid,
        'user_uuid': userUuid,
        'state': state,
        'phone_number': phoneNumber,
        'created_at': createdAt,
      };
}

class AppliedQuestResponse {
  final QuestApplyInfo questApplyInfo;
  final QuestInfo questInfo;
  const AppliedQuestResponse({
    required this.questApplyInfo,
    required this.questInfo,
  });
  AppliedQuestResponse.fromJson(Map<String, dynamic> json)
      : questApplyInfo = QuestApplyInfo.fromJson(json['apply']),
        questInfo = QuestInfo.fromJson(json['quest']);
  Map<String, dynamic> toJson() => {
        'quest_apply_info': questApplyInfo,
        'quest_info': questInfo,
      };
}

class QuestService {
  static Future<List<QuestInfo>> getActiveQuests(BuildContext context) async {
    List<QuestInfo> quests = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/quest/active');
      if (response.statusCode == 200) {
        for (final json in response.data) {
          quests.add(QuestInfo.fromJson(json));
        }
      } else {
        debugPrint('퀘스트 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 조회 실패 $e');
    }
    return quests;
  }

  static Future<List<QuestInfo>> getEndedQuest(BuildContext context) async {
    List<QuestInfo> quests = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/quest/ended');
      if (response.statusCode == 200) {
        for (final json in response.data) {
          quests.add(QuestInfo.fromJson(json));
        }
      } else {
        debugPrint('퀘스트 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 조회 실패 $e');
    }
    return quests;
  }

  static Future<List<AppliedQuestResponse>> getMyActiveQuests(
      BuildContext context) async {
    List<AppliedQuestResponse> quests = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/quest/my/active');
      if (response.statusCode == 200) {
        for (final json in response.data) {
          quests.add(AppliedQuestResponse.fromJson(json));
        }
      } else {
        debugPrint('퀘스트 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 조회 실패 $e');
    }
    return quests;
  }

  static Future<List<AppliedQuestResponse>> getMyAllQuests(
      BuildContext context) async {
    List<AppliedQuestResponse> quests = [];
    final dio = await authDio(context);
    try {
      final response = await dio.get('/quest/my/all');
      if (response.statusCode == 200) {
        for (final json in response.data) {
          quests.add(AppliedQuestResponse.fromJson(json));
        }
      } else {
        debugPrint('퀘스트 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 조회 실패 $e');
    }
    return quests;
  }

  static Future<QuestInfo> findQuestByUuid(
    BuildContext context,
    String questUuid,
  ) async {
    final dio = await authDio(context);
    QuestInfo questInfo = const QuestInfo(
      questUuid: '',
      title: '',
      shortDescription: '',
      longDescription: '',
      mission: '',
      iconUrl: '',
      thumbnailUrl: '',
      startDate: '',
      endDate: '',
      limit: 0,
      applyCount: 0,
      isEnded: false,
      createdAt: '',
    );
    try {
      final response = await dio.get(
        '/quest/find',
        queryParameters: {
          'quest_uuid': questUuid,
        },
      );
      if (response.statusCode == 200) {
        questInfo = QuestInfo.fromJson(response.data);
      } else {
        debugPrint('퀘스트 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 조회 실패 $e');
    }
    return questInfo;
  }

  static Future<void> applyQuest(
    BuildContext context,
    String questUuid,
    String phoneNumber,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/quest/apply',
        queryParameters: {
          'quest_uuid': questUuid,
          'phone_number': phoneNumber,
        },
      );
      if (response.statusCode == 201) {
        debugPrint('퀘스트 신청 성공');
      } else {
        debugPrint('퀘스트 신청 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 신청 실패 $e');
    }
  }

  static Future<QuestApplyInfo> findQuestApply(
    BuildContext context,
    String questUuid,
  ) async {
    final dio = await authDio(context);
    QuestApplyInfo questApplyInfo = const QuestApplyInfo(
      applyUuid: '',
      questUuid: '',
      userUuid: '',
      state: '',
      phoneNumber: '',
      createdAt: '',
    );
    try {
      final response = await dio.get(
        '/quest/find/apply',
        queryParameters: {
          'quest_uuid': questUuid,
        },
      );
      if (response.statusCode == 200) {
        questApplyInfo = QuestApplyInfo.fromJson(response.data);
      } else {
        debugPrint('퀘스트 신청 조회 실패');
      }
    } catch (e) {
      debugPrint('퀘스트 신청 조회 실패 $e');
    }
    return questApplyInfo;
  }
}
