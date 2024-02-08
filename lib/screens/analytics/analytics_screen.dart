import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/analytics/widgets/graph_book_record.dart';
import 'package:sprit/screens/analytics/widgets/grass_widget.dart';
import 'package:sprit/screens/analytics/widgets/monthly_count.dart';
import 'package:sprit/widgets/toggle_button.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  MonthlyRecordInfo monthlyRecordCount = const MonthlyRecordInfo(
    presentMonth: 0,
    pastMonth: 0,
  );
  @override
  void initState() {
    super.initState();
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
