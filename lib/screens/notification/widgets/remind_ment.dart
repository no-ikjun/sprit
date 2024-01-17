import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/switch_button.dart';

class RemindMentWidget extends StatelessWidget {
  final String title;
  final String description;
  final bool switchValue;
  final Function() onToggle;
  const RemindMentWidget({
    super.key,
    required this.title,
    required this.description,
    required this.switchValue,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Scaler.width(0.85, context),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorSet.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Scaler.width(0.85, context) - 80,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyles.notificationMentBookTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                width: Scaler.width(0.85, context) - 80,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        description,
                        style: TextStyles.notificationMentBookDescriptionStyle,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          CustomSwitch(
            onToggle: onToggle,
            switchValue: switchValue,
          ),
        ],
      ),
    );
  }
}
