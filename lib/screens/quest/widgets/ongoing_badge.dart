import 'package:flutter/cupertino.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class OngoingBadge extends StatelessWidget {
  final String state;
  const OngoingBadge({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    Color color = ColorSet.primary;
    if (state == 'APPLY' || state == 'CHECKING') {
      color = ColorSet.grey;
    } else if (state == 'ONGOING') {
      color = ColorSet.primary;
    } else if (state == 'SUCCESS') {
      color = ColorSet.green;
    } else if (state == 'FAIL') {
      color = ColorSet.red;
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
    } else if (state == 'CHECKING') {
      text = '검토중';
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
