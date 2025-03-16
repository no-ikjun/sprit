import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/follow.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/social/widgets/follow_button.dart';

Future<void> followUser(
  BuildContext context,
  String userUuid,
  String targetUuid,
) async {
  await FollowService.follow(context, userUuid, targetUuid);
}

Future<void> unfollowUser(
  BuildContext context,
  String userUuid,
  String targetUuid,
) async {
  await FollowService.unfollow(context, userUuid, targetUuid);
}

Future<bool> checkFollowing(
  BuildContext context,
  String userUuid,
  String targetUuid,
) async {
  return await FollowService.checkFollowing(context, userUuid, targetUuid);
}

class ProfileWidget extends StatefulWidget {
  final ProfileInfo profileInfo;

  const ProfileWidget({super.key, required this.profileInfo});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isFollowing = false;
  bool isLoading = true;

  Future<void> follow(BuildContext context) async {
    await followUser(
      context,
      context.read<UserInfoState>().userInfo.userUuid,
      widget.profileInfo.userUuid,
    );
    HapticFeedback.lightImpact();
    setState(() {
      isFollowing = true;
    });
  }

  Future<void> unfollow(BuildContext context) async {
    await unfollowUser(
      context,
      context.read<UserInfoState>().userInfo.userUuid,
      widget.profileInfo.userUuid,
    );
    HapticFeedback.lightImpact();
    setState(() {
      isFollowing = false;
    });
  }

  Future<void> checkIsFollowing(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    bool isFollowing = await checkFollowing(
      context,
      context.read<UserInfoState>().userInfo.userUuid,
      widget.profileInfo.userUuid,
    );
    setState(() {
      this.isFollowing = isFollowing;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsFollowing(context);
  }

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
                        'https://d3ob3cint7tr3s.cloudfront.net/${widget.profileInfo.image}',
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
                        SizedBox(
                          width: Scaler.width(0.85, context) - 150,
                          child: Text(
                            widget.profileInfo.nickname,
                            style: TextStyles.followNicknameStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: Scaler.width(0.85, context) - 150,
                          child: Text(
                            widget.profileInfo.description,
                            style: TextStyles.followRecordStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                isLoading
                    ? Container()
                    : FollowButton(
                        isFollowing: isFollowing,
                        onPressed: () async {
                          if (isFollowing) {
                            await unfollow(context);
                          } else {
                            await follow(context);
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
