import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

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
}
