import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/social/widgets/follow_button.dart';

class ProfileWidget extends StatelessWidget {
  final ProfileInfo profileInfo;

  const ProfileWidget({super.key, required this.profileInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Center(
          child: SizedBox(
            width: Scaler.width(0.85, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        'https://naverpa-phinf.pstatic.net/MjAyNDA5MDJfMTgw/MDAxNzI1MjY0NjI3MjMx.CM1-4Jd8ThxDStFgK6nI7AJ2f_ADiPWwAzl8ktM7HZMg.-DrgIHz3oiPplnKATOqp3mDPXap8yPoFx6vbVyvY1OAg.JPEG/342x228_17252646272195900464080537449699.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profileInfo.nickname,
                            style: TextStyles.followNicknameStyle),
                        const Text(
                          '기록 100개',
                          style: TextStyles.followRecordStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                FollowButton(
                  isFollowing: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
