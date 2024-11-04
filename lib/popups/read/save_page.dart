import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/widgets/custom_button.dart';

class SavePage extends StatefulWidget {
  const SavePage({
    super.key,
    required this.bookUuid,
    required this.recordUuid,
    required this.timeArgument,
  });

  final String bookUuid;
  final String recordUuid;
  final int timeArgument;

  @override
  State<SavePage> createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  int endPage = 0;

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
          '마지막으로 읽은 페이지를 입력해주세요',
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
        const SizedBox(
          height: 12,
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RouteName.readComplete,
                    (route) => false,
                    arguments: widget.timeArgument,
                  );
                },
                child: const Text('건너뛰기', style: TextStyles.buttonLabelStyle),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  if (endPage != 0) {
                    await RecordService.updatePageEnd(
                      context,
                      widget.recordUuid,
                      endPage,
                    );
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteName.readComplete,
                      (route) => false,
                      arguments: widget.timeArgument,
                    );
                  }
                },
                child: const Text('확인', style: TextStyles.buttonLabelStyle),
              ),
            ],
          ),
        )
      ],
    );
  }
}
