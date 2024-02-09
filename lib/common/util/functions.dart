import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
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
  if (time == 0) return '';
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
  if (difference.inDays > 0) {
    return '${difference.inDays}일 전';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}시간 전';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}분 전';
  } else {
    return '방금 전';
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
  } else if (backWeek == -1) {
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
