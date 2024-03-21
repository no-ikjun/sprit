import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/screens/quest/quest_detail_screen.dart';
import 'package:sprit/widgets/modal.dart';

showModal(BuildContext context, Widget content, bool closeButton) async {
  await showDialog<String>(
    context: context,
    builder: (context) => Modal(
      content: content,
      closeButton: closeButton,
    ),
  );
}

getColorForValue(int value, int maxValue) {
  double step = (maxValue > 0 ? maxValue : 1) / 5;
  if (value == 0) return GrassColor.grassDefault;
  if (value <= step) return GrassColor.grass1st;
  if (value <= step * 2) return GrassColor.grass2nd;
  if (value <= step * 3) return GrassColor.grass3rd;
  if (value <= step * 4) return GrassColor.grass4th;
  return GrassColor.grass5th;
}

getFormattedTime(int time) {
  if (time == 0) return '';
  if (time < 60) return '($time초)';
  if (time < 3600) return '(${(time / 60).floor()}분)';
  if (time < 86400) {
    return '(${(time / 3600).toStringAsFixed(1)}시간)';
  }
}

getFormattedTimeWithUnit(int time) {
  if (time == 0) return '0초';
  if (time < 60) return '$time초';
  if (time < 3600) {
    return '${(time / 60).floor()}분 ${time % 60 > 0 ? ' ${time % 60}초' : ''}';
  }
  if (time < 86400) {
    return '${(time / 3600).floor()}시간 ${time % 60 > 0 ? ' ${((time % 3600) / 60).floor()}분' : ''}';
  }
}

getRemainingTime(DateTime startDate) {
  final now = DateTime.now();
  final difference = startDate.difference(now);
  if (difference.isNegative) {
    return '0시간 0분 0초';
  }
  final days = difference.inDays;
  final hours = difference.inHours % 24;
  final minutes = difference.inMinutes % 60;
  final seconds = difference.inSeconds % 60;
  if (days > 0) {
    return '$days일 $hours시간 $minutes분';
  } else {
    return '$hours시간 $minutes분 $seconds초';
  }
}

getPastTime(String timeData) {
  final now = DateTime.now();
  final time = DateTime.parse(timeData);
  final difference = now.difference(time);
  if (difference.inDays > 30) {
    return '${difference.inDays ~/ 30}개월 전';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}일 전';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}

getGoingtime(String timeData) {
  final now = DateTime.now();
  final time = DateTime.parse(timeData);
  final difference = now.difference(time);
  if (difference.inDays > 0) {
    return '${difference.inDays}일째';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간째';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분째';
  } else {
    return '방금 시작';
  }
}

getFormattedDateTime(String timeData) {
  final time = DateTime.parse(timeData);
  final year = time.year;
  final month = time.month;
  final day = time.day;
  return '$year년 $month월 $day일';
}

getWeekFormat(int backWeek) {
  final now = DateTime.now();
  int adjustForSundayStart = now.weekday % 7;
  final startOfWeek =
      now.subtract(Duration(days: adjustForSundayStart + 7 * backWeek));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));
  if (backWeek == 0) {
    return '이번주';
  } else if (backWeek == 1) {
    return '저번주';
  } else {
    String formattedStart = "${startOfWeek.month}월 ${startOfWeek.day}일";
    String formattedEnd = "${endOfWeek.month}월 ${endOfWeek.day}일";
    return "$formattedStart ~ $formattedEnd";
  }
}

getSelectedDayFormat(int backWeek, int selectedIndex) {
  final now = DateTime.now();
  int adjustForSundayStart = now.weekday % 7;
  final startOfWeek =
      now.subtract(Duration(days: adjustForSundayStart + 7 * backWeek));
  final selectedDay = startOfWeek.add(Duration(days: selectedIndex));
  final year = selectedDay.year;
  final month = selectedDay.month;
  final day = selectedDay.day;
  return '$year년 $month월 $day일';
}

getQuestStatusMent(QuestApplyInfo questApplyInfo) {
  if (questApplyInfo.state == 'APPLY') {
    return '시작일';
  } else if (questApplyInfo.state == 'SUCCESS' ||
      questApplyInfo.state == 'FAIL' ||
      questApplyInfo.state == 'CHECKING') {
    return '종료일';
  } else {
    return '시작한지';
  }
}

getQuestStatusData(QuestInfo questInfo, QuestApplyInfo questApplyInfo) {
  if (questApplyInfo.state == 'APPLY') {
    return questInfo.startDate.substring(0, 10);
  } else if (questApplyInfo.state == 'SUCCESS' ||
      questApplyInfo.state == 'FAIL' ||
      questApplyInfo.state == 'CHECKING') {
    return getPastTime(questInfo.endDate);
  } else {
    return getGoingtime(questInfo.startDate);
  }
}

void handleMessage(RemoteMessage message, BuildContext context) async {
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
