import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/widgets/custom_button.dart';

class HomeBookSelect extends StatelessWidget {
  final String bookTitle;
  final String bookUuid;
  final Function onDelete;
  const HomeBookSelect({
    super.key,
    required this.bookTitle,
    required this.bookUuid,
    required this.onDelete,
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
          "어떤 작업을 수행할까요?",
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
                color: ColorSet.red.withOpacity(0.7),
                borderColor: ColorSet.red.withOpacity(0.2),
                onPressed: () {
                  onDelete();
                  Navigator.pop(context);
                },
                child: const Text(
                  '도서 삭제',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.pushNamed(
                    context,
                    RouteName.recordSetting,
                    arguments: bookUuid,
                  );
                },
                child: const Text(
                  '독서 시작',
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
