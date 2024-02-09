import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class AlreadyAppliedQuest extends StatelessWidget {
  const AlreadyAppliedQuest({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '퀘스트 신청 불가',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '이미 신청한 퀘스트입니다',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          onPressed: () {
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          child: const Text(
            '확인',
            style: TextStyles.loginButtonStyle,
          ),
        )
      ],
    );
  }
}
