import 'package:flutter/material.dart';
import 'package:sprit/screens/library/report_list_screen.dart';
import 'package:sprit/screens/quest/custom_quest/input_code_screen.dart';
import 'package:sprit/screens/home/profile_screen.dart';
import 'package:sprit/screens/library/phrase_screen.dart';
import 'package:sprit/screens/main_screen.dart';
import 'package:sprit/screens/login/login_screen.dart';
import 'package:sprit/screens/login/sign_up_screen.dart';
import 'package:sprit/screens/notice/notice_screen.dart';
import 'package:sprit/screens/notification/ment_setting_screen.dart';
import 'package:sprit/screens/notification/notification_screen.dart';
import 'package:sprit/screens/notification/time_setting_screen.dart';
import 'package:sprit/screens/quest/my_quest_screen.dart';
import 'package:sprit/screens/read/read_timer_screen.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/screens/social/search_user_screen.dart';
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
  static const bookReport = "/bookReport";
  static const profile = "/profile";
  static const questDetail = "/questDetail";
  static const myQuest = "/myQuest";
  static const questCodeInput = "/quest/input";
  static const notice = "/notice";
  static const noticeDetail = "/noticeDetail";
  static const libraryPhraseScreen = "/library/phrase";
  static const followScreen = "/follow";
  static const searchUserScreen = "/searchUser";
  static const libraryReportListScreen = "/library/reportList";
  static const userProfileScreen = "/user-profile";
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
  RouteName.profile: (context) => const ProfileScreen(),
  RouteName.myQuest: (context) => const MyQuestScreen(),
  RouteName.questCodeInput: (context) => const InputQuestCodeScreen(),
  RouteName.notice: (context) => const NoticeScreen(),
  RouteName.libraryPhraseScreen: (context) => const LibraryPhraseScreen(),
  RouteName.libraryReportListScreen: (context) => const ReportListScreen(),
  RouteName.searchUserScreen: (context) => const SearchUserScreen(),
};
