import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<void> deletePhrase(
  BuildContext context,
  String phraseUuid,
) async {
  await PhraseService.deletePhrase(context, phraseUuid);
}

class DeletePhrase extends StatelessWidget {
  final String bookTitle;
  final String phraseUuid;
  final Function callback;
  const DeletePhrase({
    super.key,
    required this.bookTitle,
    required this.phraseUuid,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Text(
          bookTitle,
          style: TextStyles.notificationConfirmModalTitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          "이 문구를 삭제할까요?",
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const Text(
          "삭제한 문구는 되돌릴 수 없어요.",
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
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
                onPressed: () async {
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
                color: ColorSet.red.withOpacity(0.7),
                borderColor: ColorSet.red.withOpacity(0.2),
                onPressed: () async {
                  await deletePhrase(context, phraseUuid);
                  Navigator.pop(context);
                  callback();
                },
                child: const Text(
                  '문구 삭제',
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
