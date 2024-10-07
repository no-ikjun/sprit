import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final VoidCallback onPressed;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isFollowing ? ColorSet.superLightGrey : ColorSet.primary,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(
              color: isFollowing ? ColorSet.superLightGrey : ColorSet.primary,
            ),
          ),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          isFollowing ? '취소' : '팔로우',
          style: TextStyles.followButtonStyle.copyWith(
            color: isFollowing ? ColorSet.text : ColorSet.white,
          ),
        ),
      ),
    );
  }
}
