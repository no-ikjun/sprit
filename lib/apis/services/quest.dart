import 'package:dio/dio.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

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
  /// 활성 퀘스트 목록 조회
  static Future<List<QuestInfo>> getActiveQuests() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/quest/active');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => QuestInfo.fromJson(json))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 종료된 퀘스트 목록 조회
  static Future<List<QuestInfo>> getEndedQuest() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/quest/ended');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => QuestInfo.fromJson(json))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 내 활성 퀘스트 목록 조회
  static Future<List<AppliedQuestResponse>> getMyActiveQuests() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/quest/my/active');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => AppliedQuestResponse.fromJson(json))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 내 모든 퀘스트 목록 조회
  static Future<List<AppliedQuestResponse>> getMyAllQuests() async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/quest/my/all');
      
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => AppliedQuestResponse.fromJson(json))
            .toList();
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 퀘스트 UUID로 조회
  static Future<QuestInfo> findQuestByUuid(String questUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/quest/find',
        queryParameters: {
          'quest_uuid': questUuid,
        },
      );
      
      if (response.statusCode == 200) {
        return QuestInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 퀘스트 신청
  static Future<void> applyQuest(
    String questUuid,
    String phoneNumber,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post(
        '/quest/apply',
        queryParameters: {
          'quest_uuid': questUuid,
          'phone_number': phoneNumber,
        },
      );
      
      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
      AppLogger.info('퀘스트 신청 성공');
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 신청 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 퀘스트 신청 정보 조회
  static Future<QuestApplyInfo> findQuestApply(String questUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get(
        '/quest/find/apply',
        queryParameters: {
          'quest_uuid': questUuid,
        },
      );
      
      if (response.statusCode == 200) {
        // 응답이 빈 문자열이거나 null인 경우 빈 QuestApplyInfo 반환
        if (response.data == null ||
            response.data == '' ||
            response.data is! Map<String, dynamic>) {
          return const QuestApplyInfo(
            applyUuid: '',
            questUuid: '',
            userUuid: '',
            state: '',
            phoneNumber: '',
            createdAt: '',
          );
        }
        return QuestApplyInfo.fromJson(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('퀘스트 신청 조회 실패', e, stackTrace);
      rethrow;
    }
  }
}