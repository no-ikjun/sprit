import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class FollowService {
  static Future<void> follow(
    BuildContext context,
    String follwerUuid,
    String followeeUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow', data: {
        'follwer_uuid': follwerUuid,
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
      final response = await dio.delete('/follow/cancel', data: {
        'follwer_uuid': follwerUuid,
        'followee_uuid': followeeUuid,
      });
      if (response.statusCode == 201) {
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
        'follwer_uuid': follwerUuid,
        'followee_uuid': followeeUuid,
      });
      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('팔로우 상태 확인 실패');
        return false;
      }
    } catch (e) {
      debugPrint('팔로우 상태 확인 실패 : $e');
      return false;
    }
  }

  static Future<List<String>> getFollowerList(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/followers', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('팔로워 목록 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('팔로워 목록 조회 실패 : $e');
      return [];
    }
  }

  static Future<List<String>> getFollowingList(
    BuildContext context,
    String userUuid,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.get('/follow/followings', queryParameters: {
        'user_uuid': userUuid,
      });
      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('팔로잉 목록 조회 실패');
        return [];
      }
    } catch (e) {
      debugPrint('팔로잉 목록 조회 실패 : $e');
      return [];
    }
  }
}
