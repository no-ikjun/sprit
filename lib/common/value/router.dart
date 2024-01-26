import 'package:flutter/material.dart';
import 'package:sprit/screens/main_screen.dart';
import 'package:sprit/screens/login/login_screen.dart';
import 'package:sprit/screens/login/sign_up_screen.dart';
import 'package:sprit/screens/notification/ment_setting_screen.dart';
import 'package:sprit/screens/notification/notification_screen.dart';
import 'package:sprit/screens/notification/time_setting_screen.dart';
import 'package:sprit/screens/read/read_timer_screen.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/screens/splash/splash_screen.dart';

class RouteName {
  static const splash = "/";
  static const home = "/home";
  static const login = "/login";
  static const signUp = "/signUp";
  static const search = "/search";
  static const notification = "/notification";
  static const timeSetting = "/notifiction/timeSetting";
  static const mentSetting = "/notifiction/mentSetting";
  static const bookDetail = "/bookDetail";
  static const review = "/review";
  static const recordSetting = "/recordSetting";
  static const readTimer = "/readTimer";
  static const readComplete = "/readComplete";
}

var namedRoutes = <String, WidgetBuilder>{
  RouteName.splash: (context) => const SplashScreen(),
  RouteName.home: (context) => const MainScreen(),
  RouteName.login: (context) => const LoginScreen(),
  RouteName.signUp: (context) => const SignUpScreen(),
  RouteName.search: (context) => const SearchScreen(),
  RouteName.notification: (context) => const NotificationScreen(),
  RouteName.timeSetting: (context) => const TimeSettingScreen(),
  RouteName.mentSetting: (context) => const MentSettingScreen(),
  RouteName.readTimer: (context) => const ReadTimerScreen(),
};
