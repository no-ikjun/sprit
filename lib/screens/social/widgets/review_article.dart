import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shimmer/shimmer.dart';
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
import 'package:sprit/widgets/star_row.dart';

class ReviewArticleData {
  final int score;
  final String content;
  const ReviewArticleData({
    required this.score,
    required this.content,
  });
  ReviewArticleData.fromJson(Map<String, dynamic> json)
      : score = json['score'] is int ? json['score'] : int.parse(json['score']),
        content = json['content'];
  Map<String, dynamic> toJson() => {
        'score': score,
        'content': content,
      };
}

class ReviewArticle extends StatefulWidget {
  final String articleUuid;
  final String userUuid;
  final String bookUuid;
  final String data;
  final String createdAt;
  const ReviewArticle({
    super.key,
    required this.articleUuid,
    required this.userUuid,
    required this.bookUuid,
    required this.data,
    required this.createdAt,
  });

  @override
  State<ReviewArticle> createState() => _ReviewArticleState();
}

class _ReviewArticleState extends State<ReviewArticle> {
  ProfileInfo? profileInfo;
  BookInfo? bookInfo;
  int likeCount = 0;
  bool isLiked = false;
  bool isLoading = false;
  ReviewArticleData? reviewArticleData;

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
      final Map<String, dynamic> decodedData = jsonDecode(widget.data);
      reviewArticleData = ReviewArticleData.fromJson(decodedData);
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? _buildShimmerEffect(context) : _buildContent(context);
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
                  offset: const Offset(0, 2),
                  blurRadius: 4,
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
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.userProfileScreen,
                arguments: profileInfo?.userUuid,
              );
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
                      'assets/images/star_color_icon.svg',
                      width: 12,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  profileInfo?.nickname ?? '',
                  style: TextStyles.articleMentStyle,
                ),
                Text(
                  '님이 리뷰를 남겼어요',
                  style: TextStyles.articleMentStyle.copyWith(
                    color: ColorSet.semiDarkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: Scaler.width(0.85, context),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  BookThumbnail(
                    imgUrl: bookInfo?.thumbnail ?? '',
                    width: 34.62,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookInfo?.title ?? '',
                          style: TextStyles.myLibraryPhraseTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        StarRowWidget(
                          star: (reviewArticleData?.score ?? 0).toDouble(),
                          size: 14,
                          gap: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              (reviewArticleData?.content ?? '').isNotEmpty
                  ? SizedBox(
                      width: Scaler.width(0.85, context) - 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            reviewArticleData?.content ?? '',
                            style: TextStyles.bookReviewContentStyle,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 12,
              ),
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
                          const SizedBox(
                            width: 6,
                          ),
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
