import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sprit/common/value/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () async {
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "access_token");
      if (accessToken != null) {
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
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // AnimatedSize(
                //   duration: const Duration(milliseconds: 500),
                //   child: SvgPicture.asset(
                //     'assets/images/splash_logo.svg',
                //     width: 60,
                //     height: 60,
                //   ),
                // ),
                Text(
                  'SPRIT',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: "IBMPlexSans",
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF72F7FF),
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
