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

  Future<void> _fetchData({bool append = false}) async {
    if (!hasMore || isLoading) return;

    setState(() {
      isLoading = true;
    });

    String userUuid = context.read<UserInfoState>().userInfo.userUuid;
    try {
      final results = await Future.wait([
        getActiveQuests(context),
        getArticleList(context, userUuid, currentPage),
      ]);

      if (!append) {
        // 초기 데이터 로드
        activeQuests = results[0] as List<QuestInfo>;
        articleInfo = results[1] as List<ArticleInfo>;
      } else {
        // 추가 데이터 로드
        final newArticles = results[1] as List<ArticleInfo>;
        if (newArticles.isEmpty) {
          hasMore = false;
        } else {
          articleInfo.addAll(newArticles);
          currentPage++;
        }
      }
    } catch (e) {
      debugPrint("데이터 로드 실패: $e");
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
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
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
              child: scrollView,
            ),
          ),
        ],
      ),
    );
  }
}
