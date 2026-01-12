import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class PatchPhrase extends StatefulWidget {
  final String bookTitle;
  final String phrase;
  final String phraseUuid;
  final Function callback;
  const PatchPhrase({
    super.key,
    required this.bookTitle,
    required this.phrase,
    required this.phraseUuid,
    required this.callback,
  });

  @override
  State<PatchPhrase> createState() => _PatchPhraseState();
}

class _PatchPhraseState extends State<PatchPhrase> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phrase);
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
        Text(
          widget.bookTitle,
          style: TextStyles.notificationConfirmModalTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '문구(스크랩)를 수정한 뒤 저장하세요',
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
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: "예) 선택. 집중. 몰입 대상을 정하자.",
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
                  if (_controller.text.isEmpty) {
                    return;
                  }
                  await PhraseService.updateOnlyPhrase(
                    widget.phraseUuid,
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
