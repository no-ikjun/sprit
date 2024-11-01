import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

class StartArticle extends StatelessWidget {
  const StartArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  'https://picsum.photos/200',
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                '최익준',
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
                  const BookThumbnail(
                    imgUrl:
                        "https://search1.kakaocdn.net/thumb/R120x174.q85/?fname=http%3A%2F%2Ft1.daumcdn.net%2Flbook%2Fimage%2F6562837%3Ftimestamp%3D20240801161131",
                    width: 62,
                    height: 90,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SizedBox(
                    height: 90,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context) - 104,
                          child: const Text(
                            'selectedBookInfo.titlsadfasdfasdfasdfe',
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
                                      .copyWith(
                                    color: ColorSet.grey,
                                  ),
                                ),
                                const Text(
                                  // selectedBookInfo.authors.isNotEmpty
                                  //     ? selectedBookInfo.authors[0]
                                  //     : '',
                                  "selectedBookInfo.authors[0]",
                                  style: TextStyles
                                      .readBookSelectedDescriptionStyle,
                                ),
                                // selectedBookInfo.translators.isNotEmpty
                                //     ? Text(
                                //         ' 번역 ',
                                //         style: TextStyles
                                //             .readBookSelectedDescriptionStyle
                                //             .copyWith(
                                //           color: ColorSet.grey,
                                //         ),
                                //       )
                                //     : SizedBox(),
                                // selectedBookInfo.translators.isNotEmpty
                                //     ? Text(
                                //         selectedBookInfo.translators[0],
                                //         style:
                                //             TextStyles.readBookSelectedDescriptionStyle,
                                //       )
                                //     : SizedBox(),
                              ],
                            ),
                            SizedBox(
                              width: Scaler.width(0.85, context) - 104,
                              child: Text(
                                'selecte',
                                // '${selectedBookInfo.publisher} · ${(selectedBookInfo.publishedAt.length > 9) ? selectedBookInfo.publishedAt.substring(0, 10) : selectedBookInfo.publishedAt}',
                                style: TextStyles
                                    .readBookSelectedDescriptionStyle
                                    .copyWith(
                                  color: ColorSet.grey,
                                ),
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
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: Scaler.width(0.85, context) - 24,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: ColorSet.lightGrey,
                          size: 26,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          '10',
                          style: TextStyles.articleFavoriteStyle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      '30분 전',
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
