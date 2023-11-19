import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';

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
}
