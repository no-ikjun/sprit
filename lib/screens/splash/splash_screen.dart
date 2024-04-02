import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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

Future<void> checkTrackingPermission(BuildContext context) async {
  if (await AppTrackingTransparency.trackingAuthorizationStatus ==
      TrackingStatus.notDetermined) {
    // Wait for dialog popping animation
    await Future.delayed(const Duration(milliseconds: 200));
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

Future<void> registerFcmToken(BuildContext context, String fcmToken) async {
  await NotificationService.registerFcmToken(context, fcmToken);
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
      final fcmToken = await FirebaseMessaging.instance.getToken();
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
        final userInfo = await UserInfoService.getUserInfo(context);
        context.read<UserInfoState>().updateUserInfo(userInfo!);
        await registerFcmToken(context, fcmToken ?? '');
        RecordInfo ongoingRecord =
            await RecordService.getNotEndedRecord(context);
        if (ongoingRecord.recordUuid != '') {
          DateTime createdAt = DateTime.parse(ongoingRecord.createdAt);
          DateTime now = DateTime.now();
          if (now.difference(createdAt).inHours >= 24) {
            prefs.remove('elapsedTime');
            prefs.remove('isRunning');
            await RecordService.deleteRecord(context, ongoingRecord.recordUuid);
          } else {
            context
                .read<SelectedRecordInfoState>()
                .updateSelectedRecord(ongoingRecord);
            await prefs.setString('recordCreated', ongoingRecord.createdAt);
            BookInfo bookInfo = await BookInfoService.getBookInfoByUuid(
              context,
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
