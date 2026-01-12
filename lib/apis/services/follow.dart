import 'package:dio/dio.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/core/network/api_client.dart';
import 'package:sprit/core/network/api_exception.dart';
import 'package:sprit/core/util/logger.dart';

class FollowService {
  /// 팔로우
  static Future<void> follow(
    String followerUuid,
    String followeeUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.post('/follow', data: {
        'follower_uuid': followerUuid,
        'followee_uuid': followeeUuid,
      });

      if (response.statusCode != 201) {
        throw ServerException.fromResponse(response);
      }
      AppLogger.info('팔로우 성공');
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('팔로우 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 언팔로우
  static Future<void> unfollow(
    String followerUuid,
    String followeeUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.delete('/follow', data: {
        'follower_uuid': followerUuid,
        'followee_uuid': followeeUuid,
      });

      if (response.statusCode != 200) {
        throw ServerException.fromResponse(response);
      }
      AppLogger.info('언팔로우 성공');
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('언팔로우 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 팔로우 상태 확인
  static Future<bool> checkFollowing(
    String followerUuid,
    String followeeUuid,
  ) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/follow/check', data: {
        'follower_uuid': followerUuid,
        'followee_uuid': followeeUuid,
      });

      if (response.statusCode == 200) {
        return response.data.toString() == 'true';
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('팔로우 상태 확인 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 팔로워 목록 조회
  static Future<List<ProfileInfo>> getFollowerList(String userUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/follow/followers', queryParameters: {
        'user_uuid': userUuid,
      });

      if (response.statusCode == 200) {
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('팔로워 목록 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 팔로잉 목록 조회
  static Future<List<ProfileInfo>> getFollowingList(String userUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/follow/followings', queryParameters: {
        'user_uuid': userUuid,
      });

      if (response.statusCode == 200) {
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('팔로잉 목록 조회 실패', e, stackTrace);
      rethrow;
    }
  }

  /// 팔로워 수 조회
  static Future<List<int>> getFollowerCount(String userUuid) async {
    try {
      final dio = ApiClient.instance.dio;
      final response = await dio.get('/follow/count', queryParameters: {
        'user_uuid': userUuid,
      });

      if (response.statusCode == 200) {
        return List<int>.from(response.data);
      } else {
        throw ServerException.fromResponse(response);
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e, stackTrace) {
      AppLogger.error('팔로워 수 조회 실패', e, stackTrace);
      rethrow;
    }
  }
}
