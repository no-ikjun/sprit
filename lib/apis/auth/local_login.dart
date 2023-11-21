import 'package:flutter/material.dart';
import 'package:sprit/apis/auth_dio.dart';

class CreateUserInfo {
  final String userId;
  final String userPassword;
  final String userNickname;
  const CreateUserInfo({
    required this.userId,
    required this.userPassword,
    required this.userNickname,
  });
}

class LoginUserInfo {
  final String userId;
  final String userPassword;
  const LoginUserInfo({
    required this.userId,
    required this.userPassword,
  });
}

class LocalAuthService {
  static Future<String> localLogin(
    BuildContext context,
    LoginUserInfo loginUserInfo,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'user_id': loginUserInfo.userId,
          'user_password': loginUserInfo.userPassword,
        },
      );
      return response.data['access_token'];
    } catch (e) {
      debugPrint('로컬 로그인 실패 $e');
    }
    return '';
  }

  static Future<String> localSignup(
    BuildContext context,
    CreateUserInfo createUserInfo,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post(
        '/user/signup',
        data: {
          'user_id': createUserInfo.userId,
          'user_password': createUserInfo.userPassword,
          'user_nickname': createUserInfo.userNickname,
        },
      );
      return response.data['access_token'];
    } catch (e) {
      debugPrint('로컬 회원가입 실패 $e');
    }
    return '';
  }
}
