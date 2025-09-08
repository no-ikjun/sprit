import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/article.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/quest/widgets/active_quest.dart';
import 'package:sprit/screens/social/widgets/phrase_article.dart';
import 'package:sprit/screens/social/widgets/review_article.dart';
import 'package:sprit/screens/social/widgets/start_article.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

Future<List<QuestInfo>> getActiveQuests(BuildContext context) async {
  return await QuestService.getActiveQuests(context);
}

Future<List<ArticleInfo>> getArticleList(
  BuildContext context,
  String userUuid,
  int page,
) async {
  return await ArticleService.getArticleList(context, userUuid, page);
}

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;
  List<QuestInfo> activeQuests = [];
  List<ArticleInfo> articleInfo = [];

  final int pageSize = 10;

  Future<void> _fetchData({bool append = false, bool refresh = false}) async {
    // append에서만 hasMore 차단; init/refresh는 항상 1페이지 다시 받음
    if ((append && !hasMore) || isLoading) return;

    setState(() => isLoading = true);

    try {
      final userUuid = context.read<UserInfoState>().userInfo.userUuid;

      // 어떤 페이지를 받을지 결정
      final int pageToLoad = refresh ? 1 : currentPage;

      final results = await Future.wait([
        getActiveQuests(context),
        getArticleList(context, userUuid, pageToLoad),
      ]);

      final fetchedQuests = results[0] as List<QuestInfo>;
      final fetchedArticles = results[1] as List<ArticleInfo>;

      if (!mounted) return;

      setState(() {
        // 퀘스트는 항상 최신으로 교체
        activeQuests = fetchedQuests;

        if (refresh) {
          // === 새로고침: 서버의 1페이지를 기준으로 상단을 재정렬 + 신규글 반영 ===
          // 1) 서버 1페이지(fetched)가 최상단이 되도록 배치
          final fetchedIds = fetchedArticles.map((e) => e.articleUuid).toSet();
          // 2) 기존 리스트에서 1페이지에 포함된 항목 제거(중복 방지)
          final rest = articleInfo
              .where((a) => !fetchedIds.contains(a.articleUuid))
              .toList();
          // 3) 합치기: 서버 1페이지 + 나머지
          articleInfo = [...fetchedArticles, ...rest];

          // 다음 무한스크롤은 2페이지부터
          currentPage = 2;
          // hasMore는 1페이지 수로 판정 (가장 안전한 휴리스틱)
          hasMore = fetchedArticles.length == pageSize;
        } else if (append) {
          // === 무한스크롤: 뒤에 붙이되 중복 제거 ===
          if (fetchedArticles.isEmpty) {
            hasMore = false;
          } else {
            final existingIds = articleInfo.map((a) => a.articleUuid).toSet();
            final onlyNew = fetchedArticles
                .where((a) => !existingIds.contains(a.articleUuid))
                .toList();
            articleInfo.addAll(onlyNew);

            // 다음 페이지로 증가
            currentPage += 1;

            // hasMore 판정
            hasMore = fetchedArticles.length == pageSize;
          }
        } else {
          // === 초기 로드 ===
          articleInfo = fetchedArticles;
          currentPage = 2;
          hasMore = fetchedArticles.length == pageSize;
        }
      });
    } catch (e) {
      debugPrint("데이터 로드 실패: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
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
    Widget scrollView = CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            currentPage = 1;
            hasMore = true;
            await _fetchData();
          },
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('소셜', style: TextStyles.questScreenTitleStyle),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteName.searchUserScreen,
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SvgPicture.asset(
                        'assets/images/add_friend_icon.svg',
                        width: 26,
                      ),
                    ),
                  ],
                ),
              ),
              isLoading && articleInfo.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        const SizedBox(height: 20),
                        ScalableInkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteName.locationScreen,
                            );
                          },
                          child: Container(
                            width: Scaler.width(0.85, context),
                            decoration: BoxDecoration(
                              color: Color(0XFFD7FDFF),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: List.generate(
                                1,
                                (index) => BoxShadow(
                                  color:
                                      const Color(0x0D000000).withOpacity(0.05),
                                  offset: const Offset(0, 0),
                                  blurRadius: 3,
                                  spreadRadius: 0,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 18,
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/location_icon.svg',
                                        width: 30,
                                      ),
                                      const SizedBox(width: 14),
                                    ],
                                  ),
                                  Expanded(
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '독서 스팟 찾기 (Beta)',
                                          style: TextStyles
                                              .socialLocationTitleStyle,
                                        ),
                                        Text(
                                          '내 주변에 독서하기 좋은 장소는?',
                                          style: TextStyles
                                              .socialLocationDescriptionStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorSet.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '지도 보기',
                                        style: TextStyles
                                            .socialLocationButtonStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Row(
                            children: [
                              Text(
                                '퀘스트',
                                style: TextStyles.socialSubTitleStyle,
                              ),
                            ],
                          ),
                        ),
                        ActiveQuestsWidget(
                          activeQuests: activeQuests,
                          isLoading: isLoading && activeQuests.isEmpty,
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Row(
                            children: [
                              Text(
                                '게시물',
                                style: TextStyles.socialSubTitleStyle,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: articleInfo.map((e) {
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
                        const SizedBox(height: 30),
                      ],
                    ),
              if (isLoading && hasMore)
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
          currentPage = 1;
          hasMore = true;
          await _fetchData();
        },
        color: ColorSet.primary,
        child: scrollView,
      );
    }

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: RemoveGlow(),
              child: ScrollsToTop(
                onScrollsToTop: (event) async {
                  if (!mounted || !_scrollController.hasClients) return;
                  try {
                    await _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  } catch (e) {
                    debugPrint("scroll-to-top failed: $e");
                  }
                },
                child: scrollView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
