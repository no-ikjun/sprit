import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/social/widgets/profile_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<List<ProfileInfo>> getProfileList(
  BuildContext context,
  String userUuid,
) async {
  return await ProfileService.getRecommendProfile(context, userUuid);
}

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({
    super.key,
  });

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final ScrollController _scrollController = ScrollController();
  List<ProfileInfo> profileList = [];

  Future<void> FetchData() async {
    String userUuid = context.read<UserInfoState>().userInfo.userUuid;
    final results = await Future.wait([
      getProfileList(context, userUuid),
    ]);
    setState(() {
      profileList = results[0];
    });
  }

  Future<void> _onRefresh() async {
    await FetchData();
  }

  @override
  void initState() {
    super.initState();
    FetchData();
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
              return ProfileWidget(
                profileInfo: ProfileInfo(
                  userUuid: profileList[index].userUuid,
                  nickname: profileList[index].nickname,
                  image: profileList[index].image,
                  description: profileList[index].description,
                  recommendList: [],
                ),
              );
            },
            childCount: profileList.length,
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
            const CustomAppBar(
              label: '소셜',
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
