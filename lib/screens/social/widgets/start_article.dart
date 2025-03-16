import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:shimmer/shimmer.dart'; // Shimmer 패키지 추가
import 'package:sprit/apis/services/article.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/profile.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

class StartArticle extends StatefulWidget {
  final String articleUuid;
  final String userUuid;
  final String bookUuid;
  final String createdAt;
  final bool clickable;
  const StartArticle({
    super.key,
    required this.articleUuid,
    required this.userUuid,
    required this.bookUuid,
    required this.createdAt,
    this.clickable = true,
  });

  @override
  State<StartArticle> createState() => _StartArticleState();
}

class _StartArticleState extends State<StartArticle> {
  ProfileInfo? profileInfo;
  BookInfo? bookInfo;
  int likeCount = 0;
  bool isLiked = false;
  bool isLoading = false;

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    final String myUserUuid = context.read<UserInfoState>().userInfo.userUuid;
    final results = await Future.wait([
      ProfileService.getProfileInfo(context, widget.userUuid),
      BookInfoService.getBookInfoByUuid(context, widget.bookUuid),
      ArticleService.getLikeCount(context, widget.articleUuid),
      ArticleService.checkLike(context, widget.articleUuid, myUserUuid),
    ]);
    setState(() {
      profileInfo = results[0] as ProfileInfo;
      bookInfo = results[1] as BookInfo;
      likeCount = results[2] as int;
      isLiked = results[3] as bool;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildShimmerEffect(context) // 로딩 중 Shimmer 효과
        : _buildContent(context); // 로딩 완료 후 컨텐츠 표시
  }

  Widget _buildShimmerEffect(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey[200]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: Scaler.width(0.85, context),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 0),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: InkWell(
            onTap: () {
              widget.clickable
                  ? Navigator.pushNamed(
                      context,
                      RouteName.userProfileScreen,
                      arguments: profileInfo?.userUuid,
                    )
                  : null;
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        "${dotenv.env['IMAGE_SERVER_URL'] ?? ''}${profileInfo?.image ?? ''}",
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            SvgPicture.asset(
                          'assets/images/default_profile.svg',
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/images/book_color_icon.svg',
                      width: 12,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Text(
                  profileInfo?.nickname ?? '',
                  style: TextStyles.articleMentStyle,
                ),
                Text(
                  '님이 독서를 시작했어요',
                  style: TextStyles.articleMentStyle.copyWith(
                    color: ColorSet.semiDarkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: Scaler.width(0.85, context),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  BookThumbnail(
                    imgUrl: bookInfo?.thumbnail ?? '',
                    width: 62,
                    height: 90,
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context) - 104,
                          child: Text(
                            bookInfo?.title ?? '',
                            style: TextStyles.readBookSelectedTitleStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '저자 ',
                                  style: TextStyles
                                      .readBookSelectedDescriptionStyle
                                      .copyWith(color: ColorSet.grey),
                                ),
                                Text(
                                  bookInfo!.authors.isNotEmpty
                                      ? bookInfo!.authors[0]
                                      : '',
                                  style: TextStyles
                                      .readBookSelectedDescriptionStyle,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Scaler.width(0.85, context) - 104,
                              child: Text(
                                '${bookInfo!.publisher} · ${(bookInfo!.publishedAt.length > 9) ? bookInfo!.publishedAt.substring(0, 10) : bookInfo!.publishedAt}',
                                style: TextStyles
                                    .readBookSelectedDescriptionStyle
                                    .copyWith(color: ColorSet.grey),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: Scaler.width(0.85, context) - 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ScalableInkWell(
                      onTap: () async {
                        final myUserUuid =
                            context.read<UserInfoState>().userInfo.userUuid;
                        if (isLiked) {
                          await ArticleService.unlikeArticle(
                            context,
                            widget.articleUuid,
                            myUserUuid,
                          );
                        } else {
                          await ArticleService.likeArticle(
                            context,
                            widget.articleUuid,
                            myUserUuid,
                          );
                        }
                        setState(() {
                          isLiked = !isLiked;
                          likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: isLiked ? ColorSet.red : ColorSet.lightGrey,
                            size: 26,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            likeCount.toString(),
                            style: TextStyles.articleFavoriteStyle.copyWith(
                              color:
                                  isLiked ? ColorSet.red : ColorSet.lightGrey,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      getPastTime(widget.createdAt),
                      style: TextStyles.articleTimeStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
