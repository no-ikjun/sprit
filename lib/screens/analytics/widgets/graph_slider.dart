import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/analytics_index.dart';

class GraphSliderWidget extends StatefulWidget {
  const GraphSliderWidget({
    super.key,
    required this.dailyTotalTimes,
    required this.bookRecordHistory,
    required this.toggleValue,
  });
  final List<List<BookRecordHistory>> bookRecordHistory;
  final List<int> dailyTotalTimes;
  final String toggleValue;

  @override
  State<GraphSliderWidget> createState() => _GraphSliderWidgetState();
}

class _GraphSliderWidgetState extends State<GraphSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.dailyTotalTimes.reduce((value, element) => value + element) ==
            0
        ? SizedBox(
            width: Scaler.width(0.85, context) - 30,
            height: 90,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              if (widget.dailyTotalTimes.length <= index) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05598,
                  height: 0,
                );
              }
              List<int> totalTimes = List.generate(7, (index) {
                if (index < widget.bookRecordHistory.length) {
                  return widget.bookRecordHistory[index]
                      .fold(0, (sum, record) => sum + record.totalTime);
                }
                return 0;
              });
              int maxTime = totalTimes.reduce(max);
              List<int> totalTimeTrue = List.filled(7, 0);
              List<int> totalTimeFalse = List.filled(7, 0);

              for (int i = 0; i < widget.bookRecordHistory.length; i++) {
                for (var record in widget.bookRecordHistory[i]) {
                  if (record.goalAchieved) {
                    totalTimeTrue[i] += record.totalTime;
                  }
                  if (record.goalAchieved == false) {
                    totalTimeFalse[i] += record.totalTime;
                  }
                }
              }

              (totalTimeTrue + totalTimeFalse).reduce(max);
              final double barHeightTrue = totalTimeTrue.isEmpty
                  ? 0
                  : (totalTimeTrue[index] / maxTime) * 90;
              final double barHeightFalse = totalTimeFalse.isEmpty
                  ? 0
                  : (totalTimeFalse[index] / maxTime) * 90;

              return InkWell(
                onTap: () {
                  context.read<AnalyticsIndex>().updateIndex(index);
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
                        width: MediaQuery.of(context).size.width * 0.05598,
                        height: barHeightFalse,
                        decoration: BoxDecoration(
                          color:
                              (context.watch<AnalyticsIndex>().index == index ||
                                      widget.toggleValue == 'week')
                                  ? ColorSet.red
                                  : ColorSet.superLightGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(4),
                            topRight: const Radius.circular(4),
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
                        width: MediaQuery.of(context).size.width * 0.05598,
                        height: barHeightTrue,
                        decoration: BoxDecoration(
                          color:
                              (context.watch<AnalyticsIndex>().index == index ||
                                      widget.toggleValue == 'week')
                                  ? ColorSet.green
                                  : ColorSet.superLightGrey,
                          borderRadius: BorderRadius.only(
                            bottomLeft: const Radius.circular(4),
                            bottomRight: const Radius.circular(4),
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
          );
  }
}
