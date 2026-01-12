import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sprit/apis/auth/apple_login.dart';
import 'package:sprit/apis/auth/kakao_login.dart';
import 'package:sprit/apis/auth/local_login.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/screens/splash/splash_screen.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

Future<String> localLogin(LoginUserInfo loginUserInfo) async {
  try {
    return await LocalAuthService.localLogin(loginUserInfo);
  } catch (e) {
    return '';
  }
}

Future<void> loginWithKaKao(BuildContext context) async {
  OAuthToken? token = await KakaoService.handleKaKaoLoginClick(
    context,
  );
  if (token != null) {
    final loginResult = await KakaoService.kakaoLogin(token);
    if (loginResult != '') {
      const storage = FlutterSecureStorage();
      await storage.write(
        key: "access_token",
        value: loginResult,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.home,
        (route) => false,
      );
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await registerFcmToken(fcmToken ?? '');
      context.read<FcmTokenState>().updateFcmToken(fcmToken ?? '');
    } else {
      debugPrint('카카오 로그인 실패');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '카카오 로그인에 실패했습니다. 다시 시도해주세요.',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    }
  } else {
    debugPrint('카카오 로그인 실패');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '카카오 로그인에 실패했습니다. 다시 시도해주세요.',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

Future<void> loginWithApple(
  BuildContext context,
  AuthorizationCredentialAppleID appleCredential,
) async {
  try {
    final loginResult = await AppleService.appleLogin(appleCredential);
    if (loginResult != '') {
      const storage = FlutterSecureStorage();
      await storage.write(
        key: "access_token",
        value: loginResult,
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.home,
        (route) => false,
      );
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await registerFcmToken(fcmToken ?? '');
      context.read<FcmTokenState>().updateFcmToken(fcmToken ?? '');
    } else {
      debugPrint('애플 로그인 실패');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '애플 로그인에 실패했습니다. 다시 시도해주세요.',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint('애플 로그인 실패 $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '애플 로그인에 실패했습니다. 다시 시도해주세요.',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _userId = '';
  String _userPassword = '';
  bool validation = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '스프릿',
                                style: TextStyles.loginTitle.copyWith(
                                  color: ColorSet.primary,
                                ),
                              ),
                              const Text(
                                '과 함께',
                                style: TextStyles.loginTitle,
                              ),
                            ],
                          ),
                          const Text(
                            '독서를 시작해볼까요?',
                            style: TextStyles.loginTitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        validation ? '먼저, 로그인이 필요해요' : '아이디와 비밀번호를 다시 확인하세요',
                        style: TextStyles.loginLabel.copyWith(
                          color:
                              validation ? ColorSet.semiDarkGrey : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomTextField(
                        hintText: '아이디',
                        onChanged: (String value) {
                          setState(() {
                            _userId = value;
                          });
                        },
                        width: Scaler.width(0.85, context),
                        height: 50,
                        padding: 15,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomTextField(
                        hintText: '비밀번호',
                        obscureText: true,
                        onChanged: (String value) {
                          setState(() {
                            _userPassword = value;
                          });
                        },
                        width: Scaler.width(0.85, context),
                        height: 50,
                        padding: 15,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onPressed: () async {
                          setState(() {
                            validation = true;
                          });
                          final loginResult = await localLogin(
                            LoginUserInfo(
                              userId: _userId,
                              userPassword: _userPassword,
                            ),
                          );
                          if (loginResult == '') {
                            setState(() {
                              validation = false;
                            });
                          } else {
                            const storage = FlutterSecureStorage();
                            await storage.write(
                              key: "access_token",
                              value: loginResult,
                            );
                            final fcmToken =
                                await FirebaseMessaging.instance.getToken();
                            await registerFcmToken(fcmToken ?? '');
                            context
                                .read<FcmTokenState>()
                                .updateFcmToken(fcmToken ?? '');
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouteName.home,
                              (route) => false,
                            );
                          }
                        },
                        width: Scaler.width(0.85, context),
                        height: 45,
                        child: const Text(
                          '로그인',
                          style: TextStyles.loginButtonStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {},
                            child: const Text(
                              '',
                              style: TextStyles.loginLabel,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.pushNamed(context, RouteName.signUp);
                            },
                            child: Column(
                              children: [
                                Text(
                                  '아직 회원이 아니신가요?',
                                  style: TextStyles.loginLabel.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Divider(
                              color: ColorSet.semiDarkGrey,
                              thickness: 1,
                            ),
                            Container(
                              width: 100,
                              height: 20,
                              color: ColorSet.background,
                              child: const Center(
                                child: Text(
                                  '간편로그인',
                                  style: TextStyles.loginLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomButton(
                        onPressed: () async {
                          await loginWithKaKao(context);
                        },
                        width: Scaler.width(0.85, context),
                        height: 45,
                        color: const Color(0xFFFEE500),
                        borderColor: const Color(0xFFFEE500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/kakao_logo.png',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '카카오 로그인',
                              style: TextStyles.loginButtonStyle.copyWith(
                                color: ColorSet.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (Platform.isIOS)
                        CustomButton(
                          onPressed: () async {
                            try {
                              final AuthorizationCredentialAppleID credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions:
                                    WebAuthenticationOptions(
                                  clientId: dotenv.env['APPLE_SERVICE_ID']!,
                                  redirectUri: Uri.parse(
                                    dotenv.env['APPLE_REDIRECT_URI']!,
                                  ),
                                ),
                              );
                              await loginWithApple(context, credential);
                            } catch (error) {
                              debugPrint('Apple login error = $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '애플 로그인에 실패했습니다. 다시 시도해주세요.',
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          width: Scaler.width(0.85, context),
                          height: 45,
                          color: const Color(0xFF000000),
                          borderColor: const Color(0xFF000000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/apple_logo.png',
                                width: 16,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Apple로 로그인',
                                style: TextStyles.loginButtonStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
