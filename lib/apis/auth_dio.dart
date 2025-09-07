import "dart:io";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:sprit/screens/login/login_screen.dart";

Future<Dio> authDio(BuildContext context, {String? contentType}) async {
  var dio = Dio();
  dio.options.baseUrl = (kReleaseMode)
      ? dotenv.env["BASE_URL"]!
      : Platform.isAndroid
          ? dotenv.env["DEBUG_BASE_URL_ANDROID"]!
          : dotenv.env["DEBUG_BASE_URL"]!;
  dio.options.contentType = contentType ?? 'application/json';

  const storage = FlutterSecureStorage();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final accessToken = await storage.read(key: "access_token");
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }, onError: (error, handler) async {
    debugPrint("authDio Error: ${error.response?.data.toString()}");
    if (error.response?.statusCode == 401 ||
        error.response?.statusCode == 400) {
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
    return handler.next(error);
  }));
  return dio;
}
