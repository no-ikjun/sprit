import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<bool> updateRecord(
    BuildContext context, String recordUuid, int endPage) async {
  return await RecordService.stopRecord(context, recordUuid, endPage);
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
  int endPage = 0;

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
        const SizedBox(
          height: 22,
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
                onPressed: () {
                  updateRecord(context, widget.recordUuid, endPage);
                  Navigator.pop(context);
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
