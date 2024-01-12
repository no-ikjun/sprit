import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/switch_button.dart';

class NotificationControlMenu extends StatelessWidget {
  final String title;
  final String description;
  final bool switchValue;
  final Function() onClick;
  final bool isSwitch;
  const NotificationControlMenu({
    Key? key,
    required this.title,
    required this.description,
    this.switchValue = false,
    required this.onClick,
    this.isSwitch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Scaler.width(0.85, context),
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.notificationControlTitleStyle,
                ),
                Text(
                  description,
                  style: TextStyles.notificationControlDescriptionStyle,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          isSwitch
              ? CustomSwitch(onToggle: onClick, switchValue: switchValue)
              : const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff7c7c7c),
                  size: 20,
                ),
        ],
      ),
    );
  }
}
