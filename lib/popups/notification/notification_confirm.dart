import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';

class NotificationConfirm extends StatelessWidget {
  final String title;
  final String description;
  final String notificationInfo;
  const NotificationConfirm({
    super.key,
    required this.title,
    required this.description,
    required this.notificationInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Text(
          title,
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        Text(
          description,
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 14,
        ),
        Text(
          notificationInfo,
          style: TextStyles.notificationConfirmModalInfoStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 18,
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
