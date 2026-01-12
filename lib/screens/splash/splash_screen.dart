import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/quest/quest_detail_screen.dart';

Future<String?> _getFcmTokenSafely() async {
  // Firebase가 아직이면 초기화 (플리스트 방식 가정; FlutterFire options 쓰면 그 코드대로)
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp();
    } catch (_) {}
  }

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // iOS는 권한 + APNs 토큰 준비까지 대기
  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

    // APNs 토큰 대기 (최대 ~6초)
    String? apns;
    for (int i = 0; i < 30; i++) {
      apns = await FirebaseMessaging.instance.getAPNSToken();
      if (apns != null) break;
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (apns == null) {
      // 아직 준비 전이면 null 반환(크래시 방지). 나중에 onTokenRefresh에서 받아도 됨.
      return null;
    }
  }

  try {
    return await FirebaseMessaging.instance.getToken();
  } on FirebaseException catch (e) {
    // 혹시라도 타이밍 이슈로 한 번 더 막히면 안전하게 무시
    if (e.plugin == 'firebase_messaging' && e.code == 'apns-token-not-set') {
      return null;
    }
    rethrow;
  }
}

Future<void> checkTrackingPermission(BuildContext context) async {
  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      TrackingStatus.notDetermined) {
    // Wait for dialog popping animation
    await Future.delayed(const Duration(milliseconds: 200));
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

Future<void> registerFcmToken(String fcmToken) async {
  try {
    await NotificationService.registerFcmToken(fcmToken);
  } catch (e) {
    // 에러 처리
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
    if (initialMessage != null) _handleMessage(initialMessage);

    // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) async {
    debugPrint('message = ${message.notification!.title}');
    if (message.data['type'] == 'notice') {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SubwayEventDetailScreen(
      //       title: message.notification!.title!,
      //       detail: "",
      //       date: "",
      //       place: "",
      //       createdAt: "",
      //       isFirstOpen: true,
      //     ),
      //   ),
      //   (route) => false,
      // );
    } else if (message.data['type'] == 'quest') {
      Navigator.pushNamed(
        context,
        RouteName.home,
        arguments: message.data['uuid'],
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuestDetailScreen(
            questUuid: message.data['uuid'],
            //isFirstOpen: true,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2100), () async {
      await checkTrackingPermission(context);
      final librarySectionOrderState = LibrarySectionOrderState();
      await librarySectionOrderState.loadOrderFromPrefs();
      //fcm token 관련
      final fcmToken = await _getFcmTokenSafely();
      debugPrint('token: $fcmToken');
      if (fcmToken != null) {
        context.read<FcmTokenState>().updateFcmToken(fcmToken);
      }
      //로그인 여부 확인
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "access_token");
      debugPrint(accessToken);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (accessToken != null) {
        try {
          final userInfo = await UserInfoService.getUserInfo();
          if (userInfo != null) {
            context.read<UserInfoState>().updateUserInfo(userInfo);
          }
        } catch (e) {
          // 에러 처리 - 로그인 화면으로 이동
          Navigator.pushReplacementNamed(context, RouteName.login);
          return;
        }
        await registerFcmToken(fcmToken ?? '');
        RecordInfo ongoingRecord = await RecordService.getNotEndedRecord();
        if (ongoingRecord.recordUuid != '') {
          DateTime createdAt = DateTime.parse(ongoingRecord.createdAt);
          DateTime now = DateTime.now();
          if (now.difference(createdAt).inHours >= 24) {
            prefs.remove('elapsedTime');
            prefs.remove('isRunning');
            try {
              await RecordService.deleteRecord(ongoingRecord.recordUuid);
            } catch (e) {
              // 에러 처리
            }
          } else {
            context
                .read<SelectedRecordInfoState>()
                .updateSelectedRecord(ongoingRecord);
            await prefs.setString('recordCreated', ongoingRecord.createdAt);
            BookInfo bookInfo = await BookInfoService.getBookInfoByUuid(
              ongoingRecord.bookUuid,
            );
            context
                .read<SelectedBookInfoState>()
                .updateSelectedBookUuid(bookInfo);
            Navigator.pushReplacementNamed(context, RouteName.home);
            Navigator.pushNamed(
              context,
              RouteName.readTimer,
              arguments: ongoingRecord.recordUuid,
            );
            return;
          }
        } else {
          prefs.remove('elapsedTime');
          prefs.remove('isRunning');
        }
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
