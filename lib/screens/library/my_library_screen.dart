import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Scaler.width(0.85, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '내 서재',
                          style: TextStyles.myLibraryTitleStyle,
                        ),
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: SvgPicture.asset(
                            'assets/images/setting_gear.svg',
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    width: Scaler.width(0.85, context),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '어디까지 읽었는지 알려드려요 🔖',
                          style: TextStyles.myLibrarySubTitleStyle,
                        ),
                        Text(
                          '책갈피 기능을 사용하려면 페이지를 기준으로 독서를 기록해주세요',
                          style: TextStyles.myLibraryWarningStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: Scaler.width(0.85, context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              BookThumbnail(
                                imgUrl: '',
                                width: 100,
                                height: 144.44,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '마지막 기록',
                                style: TextStyles.myLibraryBookMarkStyle,
                              ),
                              Text(
                                '145쪽',
                                style: TextStyles.myLibraryBookMarkPageStyle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              BookThumbnail(
                                imgUrl: '',
                                width: 100,
                                height: 144.44,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '마지막 기록',
                                style: TextStyles.myLibraryBookMarkStyle,
                              ),
                              Text(
                                '145쪽',
                                style: TextStyles.myLibraryBookMarkPageStyle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              BookThumbnail(
                                imgUrl: '',
                                width: 100,
                                height: 144.44,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '마지막 기록',
                                style: TextStyles.myLibraryBookMarkStyle,
                              ),
                              Text(
                                '145쪽',
                                style: TextStyles.myLibraryBookMarkPageStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '더보기',
                        style: TextStyles.myLibraryShowMoreStyle,
                      ),
                      SvgPicture.asset(
                        'assets/images/show_more_grey.svg',
                        width: 21,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  SizedBox(
                    width: Scaler.width(0.85, context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '나의 책 정보',
                          style: TextStyles.myLibrarySubTitleStyle,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          '읽고 있는 책',
                          style: TextStyles.myLibraryMyBookStyle,
                        ),
                        SvgPicture.asset(
                          'assets/images/show_more_semi_dark_grey.svg',
                          width: 21,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    width: Scaler.width(0.85, context),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: ColorSet.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const BookThumbnail(
                              imgUrl: '',
                              width: 76.15,
                              height: 110,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              width:
                                  Scaler.width(0.85, context) - 30 - 76.15 - 15,
                              height: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Column(
                                    children: [
                                      Text(
                                        '책 제목',
                                        style:
                                            TextStyles.myLibraryBookTitleStyle,
                                      ),
                                      Text(
                                        '작가 출판사',
                                        style:
                                            TextStyles.myLibraryBookAuthorStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '독서 기록 0개',
                                        style: TextStyles
                                            .myLibraryBookRecordCountStyle,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: ColorSet.primaryLight,
                                        ),
                                        child: Row(
                                          children: [
                                            const Text(
                                              '읽는 중',
                                              style: TextStyles
                                                  .myLibraryBookRecordStateStyle,
                                            ),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/show_more_white.svg',
                                              width: 21,
                                            )
                                          ],
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
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '더보기',
                              style: TextStyles.myLibraryShowMoreStyle,
                            ),
                            SvgPicture.asset(
                              'assets/images/show_more_grey.svg',
                              width: 21,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
