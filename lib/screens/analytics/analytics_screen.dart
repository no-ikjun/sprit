import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/analytics_index.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/analytics/widgets/graph_book_record.dart';
import 'package:sprit/screens/analytics/widgets/graph_slider.dart';
import 'package:sprit/screens/analytics/widgets/grass_widget.dart';
import 'package:sprit/widgets/toggle_button.dart';
// import 'package:sprit/screens/analytics/widgets/monthly_count.dart';

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
  CarouselController carouselController = CarouselController();

  String toggleValue = 'week';

  // 하루 단위 독서 기록(리스트)이 담긴 리스트
  List<List<BookRecordHistory>> bookRecordHistory = [];
  // 하루 단위 독서 기록의 총 시간 (최대 7일)
  List<int> dailyTotalTimes = [];

  // backWeek가 0이면 이번주, 1이면 지난주, 2이면 그 전주 ...
  int backWeek = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    int weekday = DateTime.now().weekday;
    if (backWeek != 0) {
      weekday = 6;
    }
    final data = await getBookRecordHistory(
      context,
      backWeek,
      weekday,
    );
    setState(() {
      bookRecordHistory = data;
      dailyTotalTimes = data.map((dayRecords) {
        return dayRecords.fold(0, (int sum, record) => sum + record.totalTime);
      }).toList();
      isLoading = false;
    });
  }

  void _loadLastWeek() async {
    int weekday = DateTime.now().weekday;
    if (backWeek + 1 != 0) {
      weekday = 6;
    }
    final data = await getBookRecordHistory(
      context,
      backWeek + 1,
      weekday,
    );
    setState(() {
      backWeek++;
      bookRecordHistory = data;
      dailyTotalTimes = data.map((dayRecords) {
        return dayRecords.fold(0, (int sum, record) => sum + record.totalTime);
      }).toList();
    });
  }

  void _loadNextWeek() async {
    int weekday = DateTime.now().weekday;
    if (backWeek - 1 != 0) {
      weekday = 6;
    }
    final data = await getBookRecordHistory(
      context,
      backWeek - 1,
      weekday,
    );
    setState(() {
      backWeek--;
      bookRecordHistory = data;
      dailyTotalTimes = data.map((dayRecords) {
        return dayRecords.fold(0, (int sum, record) => sum + record.totalTime);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: _loadData,
        ),
        SliverToBoxAdapter(
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
                      '기록',
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
                child: isLoading
                    ? const SizedBox(
                        height: 90,
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 12,
                            animating: true,
                          ),
                        ),
                      )
                    : bookRecordHistory.isEmpty
                        ? SizedBox(
                            width: Scaler.width(0.85, context) - 30,
                            height: 90,
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        toggleValue == 'week'
                                            ? getWeekFormat(backWeek)
                                            : getSelectedDayFormat(
                                                backWeek,
                                                context
                                                    .watch<AnalyticsIndex>()
                                                    .index,
                                              ),
                                        style:
                                            TextStyles.analyticsGraphDateStyle,
                                      ),
                                      Text(
                                        toggleValue == 'week'
                                            ? getFormattedTimeWithUnit(
                                                dailyTotalTimes.reduce(
                                                    (value, element) =>
                                                        value + element))
                                            : getFormattedTimeWithUnit(
                                                dailyTotalTimes[context
                                                    .watch<AnalyticsIndex>()
                                                    .index],
                                              ),
                                        style:
                                            TextStyles.analyticsGraphTimeStyle,
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
                                              borderRadius:
                                                  BorderRadius.circular(3),
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
                                              borderRadius:
                                                  BorderRadius.circular(3),
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
                                    child: SwipeDetector(
                                      onSwipeRight: (offset) {
                                        HapticFeedback.lightImpact();
                                        context.read<AnalyticsIndex>().reset();
                                        _loadLastWeek();
                                      },
                                      onSwipeLeft: (offset) {
                                        HapticFeedback.lightImpact();
                                        context.read<AnalyticsIndex>().reset();
                                        if (backWeek == 0) return;
                                        _loadNextWeek();
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: Scaler.width(0.85, context) -
                                                30,
                                            height: 90,
                                            color: Colors.white,
                                          ),
                                          GraphSliderWidget(
                                            dailyTotalTimes: dailyTotalTimes,
                                            bookRecordHistory:
                                                bookRecordHistory,
                                            toggleValue: toggleValue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      "일",
                                      "월",
                                      "화",
                                      "수",
                                      "목",
                                      "금",
                                      "토"
                                    ].map((day) {
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
                              dailyTotalTimes.reduce((value, element) =>
                                          value + element) !=
                                      0
                                  ? const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '독서 기록',
                                          style: TextStyles
                                              .analyticsGraphRecordMentStyle,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              dailyTotalTimes.reduce((value, element) =>
                                          value + element) !=
                                      0
                                  ? const SizedBox(
                                      height: 12,
                                    )
                                  : Container(),
                              toggleValue == 'week'
                                  ? Column(
                                      children: bookRecordHistory
                                          .expand(
                                            (dailyRecords) => dailyRecords.map(
                                              (record) => GraphBookRecord(
                                                key: ValueKey(record.bookUuid +
                                                    Random()
                                                        .nextInt(1000)
                                                        .toString()),
                                                bookUuid: record.bookUuid,
                                                totalTime: record.totalTime,
                                                goalAchieved:
                                                    record.goalAchieved,
                                                dailyTotalTime: dailyTotalTimes
                                                    .reduce((value, element) =>
                                                        value + element),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : Column(
                                      children: bookRecordHistory[context
                                              .watch<AnalyticsIndex>()
                                              .index]
                                          .map((record) {
                                        return GraphBookRecord(
                                          key: ValueKey(record.bookUuid +
                                              Random().nextInt(100).toString()),
                                          bookUuid: record.bookUuid,
                                          totalTime: record.totalTime,
                                          goalAchieved: record.goalAchieved,
                                          dailyTotalTime: dailyTotalTimes[
                                              context
                                                  .watch<AnalyticsIndex>()
                                                  .index],
                                        );
                                      }).toList(),
                                    ),
                            ],
                          ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/information_grey_icon.svg',
                      width: 12,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      '그래프 옆으로 스와이프하여 지난주/다음주로 이동',
                      style: TextStyles.notificationTimeSettingInformationStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SizedBox(
              //       width: Scaler.width(0.85, context),
              //       child: Text(
              //         '${DateFormat('y년 M월').format(DateTime.now())} 독서 현황',
              //         style: TextStyles.analyticsSubTitleStyle,
              //       ),
              //     ),
              //   ],
              // ),
              // const MonthlyCount(kind: 'COUNT'),
              // const MonthlyCount(kind: 'GOAL'),
              // const MonthlyCount(kind: 'BOOK'),
              // const SizedBox(
              //   height: 30,
              // ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(),
        ),
      ],
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: _loadData,
        child: scrollView,
      );
    }

    return SafeArea(
      maintainBottomViewPadding: true,
      child: scrollView,
    );
  }
}
