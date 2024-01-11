import 'package:flutter/cupertino.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class OngoingBadge extends StatelessWidget {
  final String state;
  const OngoingBadge({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = ColorSet.primary;
    if (state == 'APPLY') {
      color = ColorSet.grey;
    } else if (state == 'ONGOING') {
      color = ColorSet.primary;
    } else if (state == 'SUCCESS') {
      color = ColorSet.primary;
    } else if (state == 'FAIL') {
      color = ColorSet.grey;
    }
    String text = '진행중';
    if (state == 'APPLY') {
      text = '신청완료';
    } else if (state == 'ONGOING') {
      text = '진행중';
    } else if (state == 'SUCCESS') {
      text = '성공';
    } else if (state == 'FAIL') {
      text = '실패';
    }
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyles.questBadgeStyle,
      ),
    );
  }
}
