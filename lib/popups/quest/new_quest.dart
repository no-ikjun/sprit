import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/widgets/custom_button.dart';

class NewQuestModal extends StatelessWidget {
  const NewQuestModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '퀘스트 추가',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          '퀘스트 코드로 참여하거나\n새로운 퀘스트를 만들어 공유할 수 있어요',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteName.questCodeInput);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          color: ColorSet.grey,
          borderColor: ColorSet.grey,
          child: const Text(
            '퀘스트 코드로 참여하기',
            style: TextStyles.loginButtonStyle,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          color: ColorSet.primary,
          borderColor: ColorSet.primary,
          child: const Text(
            '신규 퀘스트 생성하기',
            style: TextStyles.loginButtonStyle,
          ),
        ),
      ],
    );
  }
}
