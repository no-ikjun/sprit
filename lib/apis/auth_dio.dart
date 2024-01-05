import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sprit/screens/login/login_screen.dart";

Future<Dio> authDio(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final debugMode = prefs.getBool("debugMode") ?? false;
  var dio = Dio();
  dio.options.baseUrl =
      (kReleaseMode && !debugMode) ? "" : dotenv.env["BASE_URL"]!;

  const storage = FlutterSecureStorage();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final accessToken = await storage.read(key: "access_token");
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }, onError: (error, handler) async {
    print("authDio Error: ${error.response?.data.toString()}");
    if (error.response?.statusCode == 401) {
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
    return handler.next(error);
  }));
  return dio;
}
