import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/article.dart';
import 'package:sprit/apis/services/follow.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/social/widgets/phrase_article.dart';
import 'package:sprit/screens/social/widgets/review_article.dart';
import 'package:sprit/screens/social/widgets/start_article.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<ProfileInfo> getProfileInfo(
  BuildContext context,
  String profileUuid,
) async {
  return await ProfileService.getProfileInfo(context, profileUuid);
}

Future<List<ArticleInfo>> getUserArticleList(
  BuildContext context,
  String profileUuid,
  int page,
) async {
  return await ArticleService.getUserArticleList(context, profileUuid, page);
}

Future<List<int>> getFollowCount(
  BuildContext context,
  String profileUuid,
) async {
  return await FollowService.getFollowerCount(context, profileUuid);
}

class UserProfileScreen extends StatefulWidget {
  final String profileUuid;

  const UserProfileScreen({super.key, required this.profileUuid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  ProfileInfo? profileInfo;
  int followerCount = 0;
  int followingCount = 0;
  List<ArticleInfo> articleList = [];
  bool hasMore = true;

  bool isLoading = false;

  Future<void> _fetchData({bool append = false}) async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        getProfileInfo(context, widget.profileUuid),
        getUserArticleList(context, widget.profileUuid,
            append ? articleList.length ~/ 10 + 1 : 1),
        getFollowCount(context, widget.profileUuid),
      ]);
      if (!append) {
        profileInfo = results[0] as ProfileInfo;
        final followCounts = results[2] as List<int>;
        followerCount = followCounts[0];
        followingCount = followCounts[1];
        articleList = results[1] as List<ArticleInfo>;
      } else {
        final newArticles = results[1] as List<ArticleInfo>;
        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          articleList.addAll(newArticles);
        }
      }
    } catch (e) {
      debugPrint('프로필 정보 조회 실패 $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoading) {
      _fetchData(append: true);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(
          radius: 18,
          animating: true,
        ),
      );
    }
    Widget scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            hasMore = true;
            await _fetchData();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              CustomAppBar(
                label: profileInfo?.nickname ?? '',
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        "https://d3ob3cint7tr3s.cloudfront.net/${profileInfo?.image}",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset(
                          'assets/images/default_profile.svg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: Scaler.width(0.85, context) - 120,
                      height: 95,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            profileInfo?.nickname ?? '',
                            style: TextStyles.myLibraryNicknameStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            profileInfo?.description ?? '',
                            style: TextStyles.myLibraryDescriptionStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "팔로워 ",
                                    style: TextStyles.myLibraryFollowerStyle,
                                  ),
                                  Text(
                                    "$followerCount명",
                                    style: TextStyles.myLibraryFollowerStyle
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Text(
                                " · ",
                                style: TextStyles.myLibraryFollowerStyle,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "팔로잉 ",
                                    style: TextStyles.myLibraryFollowerStyle,
                                  ),
                                  Text(
                                    "$followingCount명",
                                    style: TextStyles.myLibraryFollowerStyle
                                        .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: const Row(
                  children: [
                    Text('독서 활동', style: TextStyles.myLibrarySubTitleStyle),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: articleList.map((e) {
                  if (e.type == 'record') {
                    return StartArticle(
                      articleUuid: e.articleUuid,
                      userUuid: e.userUuid,
                      bookUuid: e.bookUuid,
                      createdAt: e.createdAt,
                    );
                  } else if (e.type == 'review') {
                    return ReviewArticle(
                      articleUuid: e.articleUuid,
                      userUuid: e.userUuid,
                      bookUuid: e.bookUuid,
                      data: e.data,
                      createdAt: e.createdAt,
                    );
                  } else if (e.type == 'phrase') {
                    return PhraseArticle(
                      articleUuid: e.articleUuid,
                      userUuid: e.userUuid,
                      bookUuid: e.bookUuid,
                      data: e.data,
                      createdAt: e.createdAt,
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
              const SizedBox(
                height: 30,
              ),
              if (hasMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CupertinoActivityIndicator(
                    radius: 15,
                    animating: true,
                  ),
                ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(),
        ),
      ],
    );

    if (Platform.isAndroid) {
      scrollView = RefreshIndicator(
        onRefresh: () async {
          hasMore = true;
          await _fetchData();
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
        child: scrollView,
      ),
    );
  }
}
