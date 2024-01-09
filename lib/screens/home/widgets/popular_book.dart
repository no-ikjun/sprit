import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/star_row.dart';

class PopularBookWidget extends StatelessWidget {
  final BookInfo bookInfo;
  final Function onTap;

  const PopularBookWidget({
    super.key,
    required this.bookInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: SizedBox(
            width: Scaler.width(0.85, context),
            child: Row(
              children: [
                BookThumbnail(
                  imgUrl: bookInfo.thumbnail,
                  width: 76.15,
                  height: 110,
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 90,
                  constraints: BoxConstraints(
                      maxWidth: Scaler.width(0.85, context) - 117),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        bookInfo.title,
                        style: TextStyles.searchResultTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              (bookInfo.authors.isNotEmpty)
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '저자 ',
                                          style: TextStyles
                                              .searchResultDetailStyle
                                              .copyWith(
                                            color: ColorSet.grey,
                                          ),
                                        ),
                                        Text(
                                          bookInfo.authors[0],
                                          style: TextStyles
                                              .searchResultDetailStyle,
                                        ),
                                      ],
                                    )
                                  : Container(),
                              (bookInfo.translators.isNotEmpty)
                                  ? Row(
                                      children: [
                                        Text(
                                          ' 번역 ',
                                          style: TextStyles
                                              .searchResultDetailStyle
                                              .copyWith(
                                            color: ColorSet.grey,
                                          ),
                                        ),
                                        Text(
                                          bookInfo.translators[0],
                                          style: TextStyles
                                              .searchResultDetailStyle,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                          Text(
                            bookInfo.publishedAt.length > 9
                                ? '${bookInfo.publisher} · ${bookInfo.publishedAt.substring(0, 10)}'
                                : '${bookInfo.publisher} · ${bookInfo.publishedAt}',
                            style: TextStyles.searchResultDetailStyle.copyWith(
                              color: ColorSet.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          StarRowWidget(star: bookInfo.star, size: 15, gap: 3),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${bookInfo.star.toString().substring(0, 3)} (${bookInfo.starCount})',
                            style: TextStyles.popularBookScoreStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
