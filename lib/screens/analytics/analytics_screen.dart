import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/screens/analytics/widgets/graph_book_record.dart';
import 'package:sprit/widgets/toggle_button.dart';

Future<List<int>> getRecordCount(BuildContext context, int count) async {
  return await RecordService.getRecordCount(context, count);
}

Future<int> getDailyTotalTime(BuildContext context, int backDate) async {
  return await RecordService.getDailyTotalTime(context, backDate);
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _recordDays = 63;

  _addValueBasedOnDayOfWeek() {
    DateTime now = DateTime.now();
    int dayOfWeek = now.weekday;
    int valueToAdd = dayOfWeek % 7 + 1;
    setState(() {
      _recordDays += valueToAdd;
    });
  }

  final List<int> _recordCount = [];
  final List<int> _maxAndMin = [0, 0];
  final List<int> _dailyTotalTime = [0, 0];

  Future<void> _getData() async {
    final results = await Future.wait([
      getRecordCount(context, _recordDays),
    ]);
    setState(() {
      _recordCount.addAll(results[0]);
      var nonZero = _recordCount.where((element) => element != 0);
      _maxAndMin[0] = nonZero.reduce(max);
      _maxAndMin[1] = nonZero.reduce(min);
    });
  }

  @override
  void initState() {
    super.initState();
    _addValueBasedOnDayOfWeek();
    _getData().then((value) async {
      int maxBackDate = _recordDays -
          1 -
          _recordCount.indexWhere((element) => element == _maxAndMin[0]);
      int minBackDate = _recordDays -
          1 -
          _recordCount.indexWhere((element) => element == _maxAndMin[1]);
      int maxTotalTime = await getDailyTotalTime(context, maxBackDate);
      int minTotalTime = await getDailyTotalTime(context, minBackDate);
      setState(() {
        _dailyTotalTime[0] = maxTotalTime;
        _dailyTotalTime[1] = minTotalTime;
      });
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
            Container(
              width: Scaler.width(0.85, context),
              padding: const EdgeInsets.all(12),
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
              child: Row(
                children: [
                  SizedBox(
                    width: (Scaler.width(0.85, context) - 24) * 0.5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_recordCount.length ~/ 7 + 1,
                          (indexRow) {
                        return Column(
                          children: List.generate(
                              indexRow == _recordCount.length ~/ 7
                                  ? _recordCount.length % 7
                                  : 7, (indexColumn) {
                            int readingAmount =
                                _recordCount[indexRow * 7 + indexColumn];
                            return Column(
                              children: [
                                Container(
                                  width: Scaler.width(0.03308, context),
                                  height: Scaler.width(0.03308, context),
                                  decoration: BoxDecoration(
                                    color: getColorForValue(readingAmount,
                                        _recordCount.reduce(max)),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                indexColumn != 6
                                    ? SizedBox(
                                        height: Scaler.width(
                                            0.007633587786, context),
                                      )
                                    : Container(),
                              ],
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    height: Scaler.width(0.007633587786, context) * 6 +
                        Scaler.width(0.03308, context) * 7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '독서기록 45개',
                              style: TextStyles.analyticsGrassTitleStyle,
                            ),
                            Text(
                              ' / $_recordDays일',
                              style: TextStyles.analyticsGrassDescriptionStyle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '가장 많이 읽은 날',
                              style: TextStyles.analyticsGrassTextStyle,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: GrassColor.grass5th,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${_maxAndMin[0]}번${getFormattedTime(_dailyTotalTime[0])}',
                                  style: TextStyles.analyticsGrassRankStyle,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${DateTime.now().subtract(Duration(days: _recordDays - 1 - _recordCount.indexWhere((element) => element == _maxAndMin[0]))).month}월 ${DateTime.now().subtract(Duration(days: _recordDays - 1 - _recordCount.indexWhere((element) => element == _maxAndMin[0]))).day}일',
                                  style: TextStyles.analyticsGrassRankDateStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '가장 적게 읽은 날',
                              style: TextStyles.analyticsGrassTextStyle,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: GrassColor.grass1st,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${_maxAndMin[1]}번${getFormattedTime(_dailyTotalTime[1])}',
                                  style: TextStyles.analyticsGrassRankStyle,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  '${DateTime.now().subtract(Duration(days: _recordDays - 1 - _recordCount.indexWhere((element) => element == _maxAndMin[1]))).month}월 ${DateTime.now().subtract(Duration(days: _recordDays - 1 - _recordCount.indexWhere((element) => element == _maxAndMin[1]))).day}일',
                                  style: TextStyles.analyticsGrassRankDateStyle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
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
              onLeftTap: () {},
              onRightTap: () {},
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2024년 1월 30일',
                            style: TextStyles.analyticsGraphDateStyle,
                          ),
                          Text(
                            '10시간 23분',
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
                                style: TextStyles.analyticsGraphIndicatorStyle,
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
                                style: TextStyles.analyticsGraphIndicatorStyle,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            return Container(
                              width: Scaler.width(0.05598, context),
                              height: 90,
                              decoration: BoxDecoration(
                                color: ColorSet.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(7, (index) {
                          String day = '';
                          switch (index) {
                            case 0:
                              day = '일';
                              break;
                            case 1:
                              day = '월';
                              break;
                            case 2:
                              day = '화';
                              break;
                            case 3:
                              day = '수';
                              break;
                            case 4:
                              day = '목';
                              break;
                            case 5:
                              day = '금';
                              break;
                            case 6:
                              day = '토';
                              break;
                          }
                          return SizedBox(
                            width: Scaler.width(0.05598, context),
                            child: Center(
                              child: Text(
                                day,
                                style:
                                    TextStyles.analyticsGraphDateIndicatorStyle,
                              ),
                            ),
                          );
                        }),
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
                  const Column(
                    children: [
                      GraphBookRecord(),
                      SizedBox(
                        height: 8,
                      ),
                      GraphBookRecord(),
                    ],
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
                  child: const Text(
                    '2024년 1월 독서 현황',
                    style: TextStyles.analyticsSubTitleStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Scaler.width(0.85, context),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '독서 기록 수',
                    style: TextStyles.analyticsMonthlyReportTitleStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        '34개',
                        style: TextStyles.analyticsMonthlyReportDataStyle,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorSet.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/up_icon_green.svg',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text(
                              '20개 ',
                              style:
                                  TextStyles.analyticsMonthlyReportAmountStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '저번 달에 비해 독서 기록을 20번 더 했어요 👏',
                    style: TextStyles.analyticsMonthlyReportMentStyle,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Scaler.width(0.85, context),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '목표 달성 횟수',
                    style: TextStyles.analyticsMonthlyReportTitleStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        '5회',
                        style: TextStyles.analyticsMonthlyReportDataStyle,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorSet.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/down_icon_red.svg',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              '3회 ',
                              style: TextStyles
                                  .analyticsMonthlyReportAmountStyle
                                  .copyWith(
                                color: ColorSet.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '저번 달보다 독서 목표 달성 횟수가 3회 줄었어요 🥲',
                    style: TextStyles.analyticsMonthlyReportMentStyle,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Scaler.width(0.85, context),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '읽은 책',
                    style: TextStyles.analyticsMonthlyReportTitleStyle,
                  ),
                  Row(
                    children: [
                      const Text(
                        '3권',
                        style: TextStyles.analyticsMonthlyReportDataStyle,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorSet.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/up_icon_green.svg',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text(
                              '1권 ',
                              style:
                                  TextStyles.analyticsMonthlyReportAmountStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '저번 달보다 책을 1권 더 읽고있어요 👍',
                    style: TextStyles.analyticsMonthlyReportMentStyle,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
