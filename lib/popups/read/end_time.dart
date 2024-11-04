import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/read/save_page.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<bool> stopRecord(
  BuildContext context,
  String recordUuid,
  int totalTime,
) async {
  return await RecordService.stopRecord(context, recordUuid, 0, totalTime);
}

Future<bool> updateGoalAchieved(
  BuildContext context,
  String recordUuid,
  bool isAchieved,
) async {
  return await RecordService.updateGoalAchieved(
    context,
    recordUuid,
    isAchieved,
  );
}

String formatTime(int second, double ratio) {
  int adjustedSeconds = (second * ratio).round();

  if (adjustedSeconds == 0) {
    return '0초';
  }

  int hours = adjustedSeconds ~/ 3600;
  int remainingSeconds = adjustedSeconds % 3600;
  int minutes = remainingSeconds ~/ 60;
  int seconds = remainingSeconds % 60;
  if (adjustedSeconds >= 3600) {
    return '$hours시간 $minutes분';
  } else if (adjustedSeconds < 60) {
    return '$seconds초';
  } else {
    return '$minutes분 $seconds초';
  }
}

class EndTime extends StatefulWidget {
  const EndTime({
    super.key,
    required this.time,
  });

  final int time;

  @override
  State<EndTime> createState() => _EndTimeState();
}

class _EndTimeState extends State<EndTime> {
  Future<void> updateTimeGoalAchieved(
    BuildContext context,
    String recordUuid,
    int goalScale,
    int time,
  ) async {
    bool isAchieved = false;
    if (time ~/ 60 >= goalScale) {
      isAchieved = true;
    }
    await RecordService.updateGoalAchieved(
      context,
      recordUuid,
      isAchieved,
    ).then((value) {
      if (value) {
        stopRecord(context, recordUuid, time);
        context.read<SelectedRecordInfoState>().updateIsAchieved(isAchieved);
      }
    });
  }

  double _value = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '독서 종료',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        Text(
          '총 독서 시간',
          style: TextStyles.notificationConfirmModalDescriptionStyle.copyWith(
            color: ColorSet.semiDarkGrey,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          formatTime(widget.time, _value),
          style: TextStyles.endReadingTimeStyle,
          textAlign: TextAlign.center,
        ),
        Slider(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
          },
          min: 0,
          max: 1,
          activeColor: ColorSet.primary,
          inactiveColor: ColorSet.superLightGrey,
          thumbColor: ColorSet.primary,
          overlayColor: WidgetStateColor.resolveWith(
            (states) => ColorSet.white.withOpacity(0),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                color: ColorSet.lightGrey,
                borderColor: ColorSet.lightGrey,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('취소', style: TextStyles.buttonLabelStyle),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  await updateTimeGoalAchieved(
                    context,
                    context
                        .read<SelectedRecordInfoState>()
                        .getSelectedRecordInfo
                        .recordUuid,
                    context
                        .read<SelectedRecordInfoState>()
                        .getSelectedRecordInfo
                        .goalScale,
                    widget.time,
                  );
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('elapsedSeconds');
                  prefs.remove('isRunning');
                  prefs.remove('recordCreated');
                  Navigator.pop(context);
                  showModal(
                    context,
                    SavePage(
                      recordUuid: context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .recordUuid,
                      bookUuid: context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .bookUuid,
                      timeArgument: (widget.time * _value).round(),
                    ),
                    false,
                  );
                },
                child: const Text('독서 종료', style: TextStyles.buttonLabelStyle),
              ),
            ],
          ),
        )
      ],
    );
  }
}
