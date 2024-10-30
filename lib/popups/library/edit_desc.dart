import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class EditDesc extends StatefulWidget {
  final String desc;
  final Function callback;

  const EditDesc({
    super.key,
    required this.desc,
    required this.callback,
  });

  @override
  State<EditDesc> createState() => _EditDescState();
}

class _EditDescState extends State<EditDesc> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.desc);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          "한 줄 소개 수정",
          style: TextStyles.notificationConfirmModalTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '소개 글을 수정한 뒤 저장하세요',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: Scaler.width(0.8, context),
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _controller.text = value;
              });
            },
            autofocus: true,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "소개 글 입력",
              hintStyle: TextStyles.timerBottomSheetHintTextStyle,
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: ColorSet.lightGrey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: ColorSet.lightGrey,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
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
                child: const Text(
                  '취소',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  String userUuid =
                      context.read<UserInfoState>().userInfo.userUuid;
                  if (_controller.text.isEmpty) {
                    return;
                  }
                  await ProfileService.updateProfileDesc(
                    context,
                    userUuid,
                    _controller.text,
                  );
                  widget.callback();
                  Navigator.pop(context);
                },
                child: const Text(
                  '수정하기',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
