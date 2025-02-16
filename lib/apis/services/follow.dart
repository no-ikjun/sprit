import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';
import 'package:sprit/apis/services/profile.dart';

class FollowService {
  static Future<void> follow(
    BuildContext context,
    String follwerUuid,
    String followeeUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post('/follow', data: {
        'follower_uuid': follwerUuid,
        'followee_uuid': followeeUuid,
      });
      if (response.statusCode == 201) {
        debugPrint('팔로우 성공');
      } else {
        debugPrint('팔로우 실패');
      }
    } catch (e) {
      debugPrint('팔로우 실패 : $e');
    }
  }

  static Future<void> unfollow(
    BuildContext context,
    String follwerUuid,
    String followeeUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.delete('/follow', data: {
        'follower_uuid': follwerUuid,
        'followee_uuid': followeeUuid,
      });
      if (response.statusCode == 200) {
        debugPrint('언팔로우 성공');
      } else {
        debugPrint('언팔로우 실패');
      }
    } catch (e) {
      debugPrint('언팔로우 실패 : $e');
    }
  }

  static Future<bool> checkFollowing(
    BuildContext context,
    String follwerUuid,
    String followeeUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/check', data: {
        'follower_uuid': follwerUuid,
        'followee_uuid': followeeUuid,
      });
      if (response.statusCode == 200) {
        return response.data.toString() == 'true';
      } else {
        debugPrint('팔로우 상태 확인 실패');
        return false;
      }
    } catch (e) {
      debugPrint('팔로우 상태 확인 실패 : $e');
      return false;
    }
  }

  static Future<List<ProfileInfo>> getFollowerList(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/followers', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        debugPrint('팔로워 목록 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('팔로워 목록 조회 실패 : $e');
      return [];
    }
  }

  static Future<List<ProfileInfo>> getFollowingList(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/followings', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        return List<ProfileInfo>.from(
          response.data.map((x) => ProfileInfo.fromJson(x)),
        );
      } else {
        debugPrint('팔로잉 목록 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('팔로잉 목록 조회 실패 : $e');
      return [];
    }
  }

  static Future<List<int>> getFollowerCount(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/count', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        return List<int>.from(response.data);
      } else {
        debugPrint('팔로워 수 조회 실패');
        return [0, 0];
      }
    } catch (e) {
      debugPrint('팔로워 수 조회 실패 : $e');
      return [0, 0];
    }
  }
}
