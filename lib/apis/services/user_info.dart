import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class UserInfoAll {
  final String userUuid;
  final String userNickame;
  final String userId;
  final String registerType;
  final String registeredAt;
  const UserInfoAll({
    required this.userUuid,
    required this.userNickame,
    required this.userId,
    required this.registerType,
    required this.registeredAt,
  });

  UserInfoAll.fromJson(Map<String, dynamic> json)
      : userUuid = json['user_uuid'],
        userNickame = json['user_nickname'],
        userId = json['user_id'],
        registerType = json['register_type'],
        registeredAt = json['registered_at'];

  Map<String, dynamic> toJson() => {
        'user_uuid': userUuid,
        'user_nickname': userNickame,
        'user_id': userId,
        'register_type': registerType,
        'registered_at': registeredAt,
      };
}

class UserInfo {
  final String userUuid;
  final String userNickname;
  final String registerType;
  const UserInfo({
    required this.userUuid,
    required this.userNickname,
    required this.registerType,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : userUuid = json['user_uuid'],
        userNickname = json['user_nickname'],
        registerType = json['register_type'];

  Map<String, dynamic> toJson() => {
        'user_uuid': userUuid,
        'user_nickname': userNickname,
        'register_type': registerType,
      };
}

class UserInfoService {
  static Future<UserInfo?> getUserInfo(BuildContext context) async {
    UserInfo? userInfo;
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/user/info',
      );
      if (response.statusCode == 200) {
        userInfo = UserInfo.fromJson(response.data);
      } else {
        debugPrint('유저 정보 조회 실패');
      }
    } catch (e) {
      debugPrint('유저 정보 조회 실패 $e');
    }
    return userInfo;
  }

  static Future<UserInfoAll> getUserInfoAll(BuildContext context) async {
    UserInfoAll userInfoAll;
    final dio = await authDio(context);
    try {
      final response = await dio.get(
        '/user/find',
      );
      if (response.statusCode == 200) {
        userInfoAll = UserInfoAll.fromJson(response.data);
      } else {
        debugPrint('유저 정보 조회 실패');
        userInfoAll = const UserInfoAll(
          userUuid: '',
          userNickame: '',
          userId: '',
          registerType: '',
          registeredAt: '',
        );
      }
    } catch (e) {
      debugPrint('유저 정보 조회 실패 $e');
      userInfoAll = const UserInfoAll(
        userUuid: '',
        userNickame: '',
        userId: '',
        registerType: '',
        registeredAt: '',
      );
    }
    return userInfoAll;
  }

  static Future<void> changeNickname(
    BuildContext context,
    String nickname,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/user/nickname',
        queryParameters: {
          'nickname': nickname,
        },
      );
      if (response.statusCode == 200) {
      } else {
        debugPrint('닉네임 변경 실패');
      }
    } catch (e) {
      debugPrint('닉네임 변경 실패 $e');
    }
  }

  static Future<void> changePassword(
    BuildContext context,
    String password,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.patch(
        '/user/password',
        queryParameters: {
          'password': password,
        },
      );
      if (response.statusCode == 200) {
      } else {
        debugPrint('비밀번호 변경 실패');
      }
    } catch (e) {
      debugPrint('비밀번호 변경 실패 $e');
    }
  }
}
