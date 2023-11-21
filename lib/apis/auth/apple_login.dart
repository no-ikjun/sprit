import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sprit/apis/auth_dio.dart';

class AppleService {
  static Future<String> appleLogin(
    BuildContext context,
    AuthorizationCredentialAppleID appleCredential,
  ) async {
    final dio = await authDio(context);
    try {
      final response = await dio.post('/auth/login/apple', data: {
        'user_identifier': appleCredential.userIdentifier,
        'given_name': appleCredential.givenName,
        'family_name': appleCredential.familyName,
        'authorization_code': appleCredential.authorizationCode,
        'email': appleCredential.email,
        'identity_token': appleCredential.identityToken,
      });
      if (response.statusCode == 201) {
        return response.data['access_token'];
      } else {
        debugPrint('애플 로그인 요청 실패');
      }
    } catch (e) {
      debugPrint('애플 로그인 요청 실패 $e');
    }
    return '';
  }
}
