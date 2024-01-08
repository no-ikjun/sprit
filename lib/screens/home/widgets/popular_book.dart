import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

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
                            bookInfo.isbn,
                            style: TextStyles.searchResultDetailStyle.copyWith(
                              color: ColorSet.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/star_yellow.svg',
                            width: 15,
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
