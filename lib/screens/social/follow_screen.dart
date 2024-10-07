import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/screens/social/widgets/profile_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class FollowScreen extends StatefulWidget {
  final String type;
  const FollowScreen({super.key, required this.type});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    Widget scrollView = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await _onRefresh();
            },
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return const ProfileWidget(
                profileInfo: ProfileInfo(
                  userUuid: 'userUuid',
                  nickname: 'nickname',
                  image: 'image',
                  description: 'desc',
                  recommendList: [],
                ),
              );
            },
            childCount: 5,
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: ColorSet.background,
          ),
        )
      ],
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: () async {
          await _onRefresh();
        },
        color: ColorSet.primary,
        child: scrollView,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            CustomAppBar(
              label: widget.type == 'follower' ? '팔로워' : '팔로잉',
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: scrollView,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
