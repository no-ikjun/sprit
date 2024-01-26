import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<bool> stopRecord(
  BuildContext context,
  String recordUuid,
  int endPage,
) async {
  return await RecordService.stopRecord(context, recordUuid, endPage);
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

Future<int> getLastPage(
  BuildContext context,
  String bookUuid,
  bool isBeforeRecord,
) async {
  return await RecordService.getLastPage(context, bookUuid, isBeforeRecord);
}

class EndPage extends StatefulWidget {
  const EndPage({
    super.key,
    required this.recordUuid,
  });

  final String recordUuid;

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  int lastPage = 0;
  int endPage = 0;

  Future<void> updateGoalAchieved(
    BuildContext context,
    String recordUuid,
    int goalScale,
    int startPage,
    int endPage,
  ) async {
    bool isAchieved = false;
    if (goalScale <= endPage - startPage + 1) {
      isAchieved = true;
    }
    await RecordService.updateGoalAchieved(
      context,
      recordUuid,
      isAchieved,
    ).then((value) {
      if (value) {
        stopRecord(context, recordUuid, endPage);
        debugPrint(isAchieved.toString());
        context.read<SelectedRecordInfoState>().updateEndPage(endPage);
        context.read<SelectedRecordInfoState>().updateIsAchieved(isAchieved);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLastPage(
      context,
      context.read<SelectedRecordInfoState>().getSelectedRecordInfo.bookUuid,
      false,
    ).then((value) {
      setState(() {
        lastPage = value;
      });
    });
  }

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
        const Text(
          '책을 어디까지 읽으셨나요?',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 130,
              height: 40,
              child: TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[0-9]'),
                  ),
                ],
                style: TextStyles.textFieldStyle.copyWith(
                  fontSize: 16,
                ),
                onChanged: (value) {
                  if (value == '') {
                    setState(() {
                      endPage = 0;
                    });
                    return;
                  }
                  setState(() {
                    endPage = int.parse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: '종료 페이지 번호',
                  hintStyle: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.grey,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorSet.semiDarkGrey, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(5),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorSet.grey,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '쪽',
              style: TextStyles.readBookSettingMentStyle.copyWith(
                color: ColorSet.semiDarkGrey,
              ),
            ),
          ],
        ),
        (lastPage != 0 && lastPage > endPage && endPage != 0)
            ? const SizedBox(
                height: 10,
              )
            : const SizedBox(
                height: 20,
              ),
        (lastPage != 0 && lastPage > endPage && endPage != 0)
            ? Text(
                '저번에 $lastPage쪽까지 읽지 않으셨나요?',
                style: TextStyles.endReadingPageValidationStyle,
              )
            : Container(),
        (lastPage != 0 && lastPage > endPage && endPage != 0)
            ? const SizedBox(
                height: 12,
              )
            : Container(),
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
                  if (endPage != 0) {
                    await updateGoalAchieved(
                      context,
                      context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .recordUuid,
                      context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .goalScale,
                      context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .pageStart,
                      endPage,
                    );
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.readComplete,
                      (route) => false,
                      arguments: endPage -
                          context
                              .read<SelectedRecordInfoState>()
                              .getSelectedRecordInfo
                              .pageStart +
                          1,
                    );
                  }
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
