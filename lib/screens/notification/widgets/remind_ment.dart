import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/switch_button.dart';

class RemindMentWidget extends StatelessWidget {
  const RemindMentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Scaler.width(0.85, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '역행자',
                style: TextStyles.notificationMentBookTitleStyle,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                '매일 독서 시간을 알려드립니다.',
                style: TextStyles.notificationMentBookDescriptionStyle,
              ),
            ],
          ),
          CustomSwitch(
            onToggle: () {},
            switchValue: true,
          ),
        ],
      ),
    );
  }
}
