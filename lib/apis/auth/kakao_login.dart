import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:sprit/core/network/api_client.dart';

class KakaoAuthTokenInfo {
  final String accessToken;
  final String expiresAt;
  final String refreshToken;
  final String refreshTokenExpiresAt;
  final String scopes;
  final String idToken;
  KakaoAuthTokenInfo({
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
    required this.scopes,
    required this.idToken,
  });

  KakaoAuthTokenInfo.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        expiresAt = json['expires_at'],
        refreshToken = json['refresh_token'],
        refreshTokenExpiresAt = json['refresh_token_expires_at'],
        scopes = json['scopes'],
        idToken = json['id_token'];

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'expires_at': expiresAt,
        'refresh_token': refreshToken,
        'refresh_token_expires_at': refreshTokenExpiresAt,
        'scopes': scopes,
        'id_token': idToken,
      };
}

class KakaoService {
  static Future<OAuthToken?> handleKaKaoLoginClick(BuildContext context) async {
    OAuthToken? token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
      } catch (e) {
        debugPrint('카카오톡으로 로그인 실패 $e');
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
        } catch (e) {
          debugPrint('카카오계정으로 로그인 실패 $e');
        }
      }
    } else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
      } catch (e) {
        debugPrint('카카오계정으로 로그인 실패 $e');
        token = null;
      }
    }
    return token;
  }

  static Future<String> kakaoLogin(
    OAuthToken authToken,
  ) async {
    final dio = ApiClient.instance.dio;
    try {
      final response = await dio.post('/auth/login/kakao', data: {
        'access_token': authToken.accessToken,
        'refresh_token': authToken.refreshToken,
        'expires_at': authToken.expiresAt.toString(),
        'refresh_token_expires_at': authToken.refreshTokenExpiresAt.toString(),
        'id_token': authToken.idToken,
      });
      if (response.statusCode == 201) {
        return response.data['access_token'];
      } else {
        debugPrint('카카오 로그인 요청 실패');
      }
    } catch (e) {
      debugPrint('카카오 로그인 요청 실패 $e');
    }
    return '';
  }
}
