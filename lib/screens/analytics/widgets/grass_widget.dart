import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';

Future<List<int>> getRecordCount(BuildContext context, int count) async {
  return await RecordService.getRecordCount(context, count);
}

Future<int> getDailyTotalTime(BuildContext context, int backDate) async {
  return await RecordService.getDailyTotalTime(context, backDate);
}

class GrassWidget extends StatefulWidget {
  const GrassWidget({super.key});

  @override
  State<GrassWidget> createState() => _GrassWidgetState();
}

class _GrassWidgetState extends State<GrassWidget> {
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
  Widget build(BuildContext context) {
    return _recordCount.isEmpty
        ? Container()
        : Container(
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
                    children:
                        List.generate(_recordCount.length ~/ 7 + 1, (indexRow) {
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
                                  color: getColorForValue(
                                      readingAmount, _recordCount.reduce(max)),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              indexColumn != 6
                                  ? SizedBox(
                                      height:
                                          Scaler.width(0.007633587786, context),
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
                          Text(
                            '독서기록 ${_recordCount.reduce((value, element) => value + element)}개',
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
          );
  }
}
