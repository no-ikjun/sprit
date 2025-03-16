import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/social/widgets/profile_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<List<ProfileInfo>> getProfileList(
  BuildContext context,
  String userUuid,
) async {
  return await ProfileService.getRecommendProfile(context, userUuid);
}

Future<List<ProfileInfo>> searchProfile(
  BuildContext context,
  String searchValue,
  String userUuid,
) async {
  return await ProfileService.searchProfile(
    context,
    searchValue,
    userUuid,
  );
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
  final TextEditingController _searchController = TextEditingController();
  List<ProfileInfo> profileList = [];
  String searchValue = '';
  bool isLoading = false;
  Timer? _debounce;

  // Debounce 메서드 추가
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          searchValue = query;
        });
        fetchData();
      }
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    String userUuid = context.read<UserInfoState>().userInfo.userUuid;
    List<ProfileInfo> result = [];

    if (searchValue.isEmpty) {
      result = await getProfileList(context, userUuid);
    } else {
      result = await searchProfile(context, searchValue, userUuid);
    }

    if (mounted) {
      setState(() {
        profileList = result;
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
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
        profileList.isEmpty
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    '검색 결과가 없습니다',
                    style: TextStyles.socialSubTitleStyle.copyWith(
                      fontSize: 16,
                      color: ColorSet.grey,
                    ),
                  ),
                ),
              )
            : isLoading
                ? const SliverFillRemaining(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 15,
                        animating: true,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ProfileWidget(
                          profileInfo: profileList[index],
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
              label: '사용자 검색',
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: Scaler.width(0.85, context),
              height: 45,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async {
                  await fetchData();
                },
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '닉네임 검색',
                  hintStyle: TextStyles.textFieldStyle.copyWith(
                    color: ColorSet.grey,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: ColorSet.grey, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: ColorSet.border, width: 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: ColorSet.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
