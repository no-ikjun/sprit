import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2000), () async {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "access_token");
      debugPrint(accessToken);
      if (accessToken != null) {
        final userInfo = await UserInfoService.getUserInfo(context);
        context.read<UserInfoState>().updateUserInfo(userInfo!);
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
              'assets/images/splash_animation.gif',
              width: Scaler.width(0.5, context),
            ),
          ],
        ),
      ),
    );
  }
}
