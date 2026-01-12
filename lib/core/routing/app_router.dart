import 'package:flutter/material.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/screens/library/book_report_screen.dart';
import 'package:sprit/screens/notice/notice_detail_screen.dart';
import 'package:sprit/screens/quest/quest_detail_screen.dart';
import 'package:sprit/screens/read/add_record_screen.dart';
import 'package:sprit/screens/read/read_complete_screen.dart';
import 'package:sprit/screens/read/record_setting_screen.dart';
import 'package:sprit/screens/search/detail_screen.dart';
import 'package:sprit/screens/search/review_screen.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/screens/social/follow_screen.dart';
import 'package:sprit/screens/social/porofile_screen.dart';
import 'package:sprit/screens/splash/splash_screen.dart';

/// 라우트 생성 로직을 중앙화한 클래스
class AppRouter {
  AppRouter._();

  /// onGenerateRoute 핸들러
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.bookDetail:
        final String bookUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BookDetailScreen(bookUuid: bookUuid),
        );

      case RouteName.review:
        final String bookUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => ReviewScreen(bookUuid: bookUuid),
        );

      case RouteName.recordSetting:
        final String bookUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => RecordSettingScreen(bookUuid: bookUuid),
        );

      case RouteName.addRecordScreen:
        final String bookUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => AddRecordScreen(bookUuid: bookUuid),
        );

      case RouteName.readComplete:
        final int goalAmount = settings.arguments as int;
        return MaterialPageRoute(
          builder: (context) => ReadCompleteScreen(goalAmount: goalAmount),
        );

      case RouteName.bookReport:
        final String reportUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BookReportScreen(reportUuid: reportUuid),
        );

      case RouteName.questDetail:
        final String questUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => QuestDetailScreen(questUuid: questUuid),
        );

      case RouteName.noticeDetail:
        final String recordUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => NoticeDetailScreen(recordUuid: recordUuid),
        );

      case RouteName.followScreen:
        final String type = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => FollowScreen(type: type),
        );

      case RouteName.search:
        final String redirect = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => SearchScreen(redirect: redirect),
        );

      case RouteName.userProfileScreen:
        final String profileUuid = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => UserProfileScreen(profileUuid: profileUuid),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
    }
  }
}
