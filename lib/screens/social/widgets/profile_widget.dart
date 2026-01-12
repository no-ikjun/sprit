import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/follow.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/social/widgets/follow_button.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

Future<void> followUser(
  String userUuid,
  String targetUuid,
) async {
  try {
    await FollowService.follow(userUuid, targetUuid);
  } catch (e) {
    // 에러 처리
    rethrow;
  }
}

Future<void> unfollowUser(
  String userUuid,
  String targetUuid,
) async {
  try {
    await FollowService.unfollow(userUuid, targetUuid);
  } catch (e) {
    // 에러 처리
    rethrow;
  }
}

Future<bool> checkFollowing(
  String userUuid,
  String targetUuid,
) async {
  try {
    return await FollowService.checkFollowing(userUuid, targetUuid);
  } catch (e) {
    return false;
  }
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
    try {
      await followUser(
        context.read<UserInfoState>().userInfo.userUuid,
        widget.profileInfo.userUuid,
      );
      HapticFeedback.lightImpact();
      setState(() {
        isFollowing = true;
      });
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> unfollow(BuildContext context) async {
    try {
      await unfollowUser(
        context.read<UserInfoState>().userInfo.userUuid,
        widget.profileInfo.userUuid,
      );
      HapticFeedback.lightImpact();
      setState(() {
        isFollowing = false;
      });
    } catch (e) {
      // 에러 처리
    }
  }

  Future<void> checkIsFollowing(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    try {
      bool isFollowing = await checkFollowing(
        context.read<UserInfoState>().userInfo.userUuid,
        widget.profileInfo.userUuid,
      );
      setState(() {
        this.isFollowing = isFollowing;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
          child: ScalableInkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.userProfileScreen,
                arguments: widget.profileInfo.userUuid,
              );
            },
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
        ),
      ],
    );
  }
}
