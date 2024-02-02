import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/user_info.dart';

Future<void> registerFcmToken(BuildContext context, String fcmToken) async {
  await NotificationService.registerFcmToken(context, fcmToken);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2100), () async {
      final librarySectionOrderState = LibrarySectionOrderState();
      await librarySectionOrderState.loadOrderFromPrefs();
      //fcm token 관련
      final fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('token: $fcmToken');
      if (fcmToken != null) {
        context.read<FcmTokenState>().updateFcmToken(fcmToken);
      }
      //로그인 여부 확인
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "access_token");
      debugPrint(accessToken);
      if (accessToken != null) {
        final userInfo = await UserInfoService.getUserInfo(context);
        context.read<UserInfoState>().updateUserInfo(userInfo!);
        await registerFcmToken(context, fcmToken ?? '');
        Navigator.pushReplacementNamed(context, RouteName.home);
        return;
      }
      Navigator.pushReplacementNamed(context, RouteName.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/launch_animation.gif',
              width: Scaler.width(0.5, context),
            ),
          ],
        ),
      ),
    );
  }
}
