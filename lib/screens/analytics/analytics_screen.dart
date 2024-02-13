import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/analytics/widgets/graph_book_record.dart';
import 'package:sprit/screens/analytics/widgets/grass_widget.dart';
import 'package:sprit/screens/analytics/widgets/monthly_count.dart';
import 'package:sprit/widgets/toggle_button.dart';

Future<List<List<BookRecordHistory>>> getBookRecordHistory(
  BuildContext context,
  int backWeek,
  int weekday,
) async {
  return await RecordService.getWeeklyRecord(context, backWeek, weekday);
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String toggleValue = 'week';

  List<List<BookRecordHistory>> bookRecordHistory = [];
  List<int> dailyTotalTimes = [];
  int maxTime = 0;
  int selectedIndex = 0;

  int backWeek = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data =
        await getBookRecordHistory(context, backWeek, DateTime.now().weekday);
    setState(() {
      if (backWeek == 0) {
        bookRecordHistory = data;
        dailyTotalTimes = data.map((dayRecords) {
          return dayRecords.fold(
              0, (int sum, record) => sum + record.totalTime);
        }).toList();
        maxTime = dailyTotalTimes.reduce(max);
      } else {
        // 이전 주의 데이터를 추가하는 경우
        bookRecordHistory.insertAll(0, data);
        dailyTotalTimes = data.map((dayRecords) {
          return dayRecords.fold(
              0, (int sum, record) => sum + record.totalTime);
        }).toList();
        maxTime = dailyTotalTimes.reduce(max);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Text(
                    '독서 기록',
                    style: TextStyles.analyticsTitleStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const GrassWidget(),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Text(
                    '독서량 추세',
                    style: TextStyles.analyticsSubTitleStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            CustomToggleButton(
              width: Scaler.width(0.85, context),
              height: 40,
              padding: 3,
              radius: 8,
              onLeftTap: () {
                AmplitudeService().logEvent(
                  AmplitudeEvent.analyticsToggleValue,
                  context.read<UserInfoState>().userInfo.userUuid,
                  eventProperties: {
                    'value': 'week',
                  },
                );
                setState(() {
                  toggleValue = 'week';
                });
              },
              onRightTap: () {
                AmplitudeService().logEvent(
                  AmplitudeEvent.analyticsToggleValue,
                  context.read<UserInfoState>().userInfo.userUuid,
                  eventProperties: {
                    'value': 'day',
                  },
                );
                setState(() {
                  toggleValue = 'day';
                });
              },
              leftText: const Text(
                '일주일',
                style: TextStyles.toggleButtonLabelStyle,
              ),
              rightText: const Text(
                '하루',
                style: TextStyles.toggleButtonLabelStyle,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Scaler.width(0.85, context),
              padding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: bookRecordHistory.isEmpty
                  ? SizedBox(
                      width: Scaler.width(0.85, context),
                      height: 200,
                      child: const CupertinoActivityIndicator(
                        radius: 15,
                        animating: true,
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toggleValue == 'week'
                                      ? getWeekFormat(backWeek)
                                      : getSelectedDayFormat(
                                          backWeek, selectedIndex),
                                  style: TextStyles.analyticsGraphDateStyle,
                                ),
                                Text(
                                  toggleValue == 'week'
                                      ? getFormattedTimeWithUnit(dailyTotalTimes
                                          .reduce((value, element) =>
                                              value + element))
                                      : getFormattedTimeWithUnit(
                                          dailyTotalTimes[selectedIndex]),
                                  style: TextStyles.analyticsGraphTimeStyle,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: ColorSet.green,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text(
                                      '목표 달성 성공',
                                      style: TextStyles
                                          .analyticsGraphIndicatorStyle,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: ColorSet.red,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Text(
                                      '목표 달성 실패',
                                      style: TextStyles
                                          .analyticsGraphIndicatorStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 90,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(7, (index) {
                                  if (dailyTotalTimes.length <= index) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.05598,
                                      height: 0,
                                    );
                                  }
                                  List<int> totalTimes =
                                      List.generate(7, (index) {
                                    if (index < bookRecordHistory.length) {
                                      return bookRecordHistory[index].fold(
                                          0,
                                          (sum, record) =>
                                              sum + record.totalTime);
                                    }
                                    return 0;
                                  });
                                  int maxTime = totalTimes.reduce(max);
                                  List<int> totalTimeTrue = List.filled(7, 0);
                                  List<int> totalTimeFalse = List.filled(7, 0);

                                  for (int i = 0;
                                      i < bookRecordHistory.length;
                                      i++) {
                                    for (var record in bookRecordHistory[i]) {
                                      if (record.goalAchieved) {
                                        totalTimeTrue[i] += record.totalTime;
                                      }
                                      if (record.goalAchieved == false) {
                                        totalTimeFalse[i] += record.totalTime;
                                      }
                                    }
                                  }

                                  (totalTimeTrue + totalTimeFalse).reduce(max);
                                  final double barHeightTrue =
                                      (totalTimeTrue[index] / maxTime) * 90;
                                  final double barHeightFalse =
                                      (totalTimeFalse[index] / maxTime) * 90;

                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // 목표 달성 실패 (false) 부분
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 90,
                                            minHeight: 0,
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05598,
                                            height: barHeightFalse,
                                            decoration: BoxDecoration(
                                              color: (selectedIndex == index ||
                                                      toggleValue == 'week')
                                                  ? ColorSet.red
                                                  : ColorSet.superLightGrey,
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(4),
                                                topRight:
                                                    const Radius.circular(4),
                                                bottomLeft: barHeightTrue == 0
                                                    ? const Radius.circular(4)
                                                    : const Radius.circular(0),
                                                bottomRight: barHeightTrue == 0
                                                    ? const Radius.circular(4)
                                                    : const Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // 목표 달성 성공 (true) 부분
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxHeight: 90,
                                            minHeight: 0,
                                          ),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05598,
                                            height: barHeightTrue,
                                            decoration: BoxDecoration(
                                              color: (selectedIndex == index ||
                                                      toggleValue == 'week')
                                                  ? ColorSet.green
                                                  : ColorSet.superLightGrey,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    const Radius.circular(4),
                                                bottomRight:
                                                    const Radius.circular(4),
                                                topLeft: barHeightFalse == 0
                                                    ? const Radius.circular(4)
                                                    : const Radius.circular(0),
                                                topRight: barHeightFalse == 0
                                                    ? const Radius.circular(4)
                                                    : const Radius.circular(0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            // 요일 표시
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: ["일", "월", "화", "수", "목", "금", "토"]
                                  .map((day) {
                                return SizedBox(
                                  width: Scaler.width(0.05598, context),
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyles
                                          .analyticsGraphDateIndicatorStyle,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '독서 기록',
                              style: TextStyles.analyticsGraphRecordMentStyle,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        toggleValue == 'week'
                            ? Column(
                                children: bookRecordHistory
                                    .expand((dailyRecords) => dailyRecords
                                        .map((record) => GraphBookRecord(
                                              key: ValueKey(record.bookUuid +
                                                  Random()
                                                      .nextInt(100)
                                                      .toString()),
                                              bookUuid: record.bookUuid,
                                              totalTime: record.totalTime,
                                              goalAchieved: record.goalAchieved,
                                              dailyTotalTime: dailyTotalTimes
                                                  .reduce((value, element) =>
                                                      value + element),
                                            )))
                                    .toList(),
                              )
                            : Column(
                                children: bookRecordHistory[selectedIndex]
                                    .map((record) {
                                  return GraphBookRecord(
                                    key: ValueKey(record.bookUuid +
                                        Random().nextInt(100).toString()),
                                    bookUuid: record.bookUuid,
                                    totalTime: record.totalTime,
                                    goalAchieved: record.goalAchieved,
                                    dailyTotalTime:
                                        dailyTotalTimes[selectedIndex],
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Text(
                    '${DateFormat('y년 M월').format(DateTime.now())} 독서 현황',
                    style: TextStyles.analyticsSubTitleStyle,
                  ),
                ),
              ],
            ),
            const MonthlyCount(kind: 'COUNT'),
            const MonthlyCount(kind: 'GOAL'),
            const MonthlyCount(kind: 'BOOK'),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
