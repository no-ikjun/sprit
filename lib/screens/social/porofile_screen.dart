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
  int page = 1;
  bool isLoading = false;
  bool articleLoading = false;

  Future<void> _fetchData() async {
    try {
      final newProfileInfo = await getProfileInfo(context, widget.profileUuid);
      final newArticles = await getUserArticleList(
        context,
        widget.profileUuid,
        page,
      );
      final followCounts = await getFollowCount(context, widget.profileUuid);

      profileInfo = newProfileInfo;
      followerCount = followCounts[0];
      followingCount = followCounts[1];
      articleList = newArticles;

      if (newArticles.length < 10) {
        hasMore = false;
      }
      setState(() {
        page = 2;
      });
    } catch (e) {
      debugPrint('프로필 정보 조회 실패 $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMore() async {
    if (articleLoading) return;
    setState(() {
      articleLoading = true;
    });
    try {
      debugPrint("page: $page");
      final newArticles = await getUserArticleList(
        context,
        widget.profileUuid,
        page,
      );

      if (newArticles.isEmpty) {
        hasMore = false;
      } else {
        articleList.addAll(newArticles);
        setState(() {
          page++;
        });
      }
    } catch (e) {
      debugPrint('프로필 정보 조회 실패 $e');
    } finally {
      if (mounted) {
        setState(() {
          articleLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (!hasMore || isLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _loadMore();
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
    if (isLoading || profileInfo == null) {
      return const Scaffold(
        backgroundColor: ColorSet.background,
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(label: ''),
              Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 18,
                    animating: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Widget scrollView = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _CustomAppBarDelegate(
            child: CustomAppBar(
              label: profileInfo?.nickname ?? '',
            ),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            hasMore = true;
            await _fetchData();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
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
                      clickable: false,
                    );
                  } else if (e.type == 'review') {
                    return ReviewArticle(
                      articleUuid: e.articleUuid,
                      userUuid: e.userUuid,
                      bookUuid: e.bookUuid,
                      data: e.data,
                      createdAt: e.createdAt,
                      clickable: false,
                    );
                  } else if (e.type == 'phrase') {
                    return PhraseArticle(
                      articleUuid: e.articleUuid,
                      userUuid: e.userUuid,
                      bookUuid: e.bookUuid,
                      data: e.data,
                      createdAt: e.createdAt,
                      clickable: false,
                    );
                  } else {
                    return Container();
                  }
                }).toList(),
              ),
              const SizedBox(
                height: 30,
              ),
              if (articleLoading)
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
          child: Container(
            color: Colors.transparent,
          ),
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

class _CustomAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _CustomAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: ColorSet.background, // 앱바 배경색 지정
      child: child,
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
