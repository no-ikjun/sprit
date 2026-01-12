import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/core/util/logger.dart';
import 'package:sprit/firebase_options.dart';

/// 앱 초기화 로직을 중앙화한 클래스
class AppInitializer {
  AppInitializer._();

  /// 모든 초기화 작업 수행
  static Future<void> initialize() async {
    try {
      // 1. 시스템 설정
      await _initializeSystemSettings();

      // 2. 환경 변수 로드
      await _loadEnvironmentVariables();

      // 3. 광고 초기화
      await _initializeAds();

      // 4. Firebase 초기화
      await _initializeFirebase();

      // 5. Kakao SDK 초기화
      _initializeKakao();

      // 6. Naver Map 초기화
      await _initializeNaverMap();

      // 7. Amplitude 초기화
      await _initializeAmplitude();

      AppLogger.info('App initialization completed');
    } catch (e, stackTrace) {
      AppLogger.error('App initialization failed', e, stackTrace);
      rethrow;
    }
  }

  /// 시스템 설정 초기화
  static Future<void> _initializeSystemSettings() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  /// 환경 변수 로드
  static Future<void> _loadEnvironmentVariables() async {
    await dotenv.load(fileName: '.env');
  }

  /// 광고 초기화
  static Future<void> _initializeAds() async {
    await MobileAds.instance.initialize();
  }

  /// Firebase 초기화
  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // 포그라운드 메시지 리스너
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLogger.debug('Got a message whilst in the foreground!');
      AppLogger.debug('Message data: ${message.data}');

      if (message.notification != null) {
        AppLogger.debug(
          'Message also contained a notification: ${message.notification}',
        );
      }
    });
  }

  /// Kakao SDK 초기화
  static void _initializeKakao() {
    final kakaoKey = dotenv.env['KAKAO_NATIVE_APP_KEY'];
    if (kakaoKey != null) {
      KakaoSdk.init(nativeAppKey: kakaoKey);
    } else {
      AppLogger.warning('KAKAO_NATIVE_APP_KEY not found');
    }
  }

  /// Naver Map 초기화
  static Future<void> _initializeNaverMap() async {
    final clientId = dotenv.env['NAVER_MAP_CLIENT_ID'];
    if (clientId != null) {
      await FlutterNaverMap().init(
        clientId: clientId,
        onAuthFailed: (ex) {
          switch (ex) {
            case NQuotaExceededException(:final message):
              AppLogger.warning('Naver Map quota exceeded: $message');
              break;
            case NUnauthorizedClientException() ||
                  NClientUnspecifiedException() ||
                  NAnotherAuthFailedException():
              AppLogger.error('Naver Map auth failed', ex);
              break;
          }
        },
      );
    } else {
      AppLogger.warning('NAVER_MAP_CLIENT_ID not found');
    }
  }

  /// Amplitude 초기화
  static Future<void> _initializeAmplitude() async {
    await AmplitudeService().init();
  }
}
