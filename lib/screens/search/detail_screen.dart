import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/book/register_book_library.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';
import 'package:sprit/widgets/star_row.dart';
import 'package:url_launcher/url_launcher.dart';

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String uuid,
) async {
  return await BookInfoService.getBookInfoByUuid(uuid);
}

Future<bool> setBookLibrary(
  String bookUuid,
  String state,
) async {
  try {
    return await BookLibraryService.setBookLibrary(bookUuid, state);
  } catch (e) {
    return false;
  }
}

class BookDetailScreen extends StatefulWidget {
  final String bookUuid;

  const BookDetailScreen({super.key, required this.bookUuid});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  BookInfo bookInfo = const BookInfo(
    bookUuid: '',
    isbn: '',
    title: '',
    authors: [],
    publisher: '',
    translators: [],
    searchUrl: '',
    thumbnail: '',
    content: '',
    publishedAt: '',
    updatedAt: '',
    score: 0,
    star: 0,
    starCount: 0,
  );
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();
  bool _showButton = true;

  Future<void> getBookInfo() async {
    setState(() {
      isLoading = true;
    });
    final BookInfo bookInfo = await getBookInfoByUuid(
      context,
      widget.bookUuid,
    );
    setState(() {
      this.bookInfo = bookInfo;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getBookInfo();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showButton = false;
      });
    } else {
      setState(() {
        _showButton = true;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: '상세 정보',
            ),
            isLoading
                ? const Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      CupertinoActivityIndicator(
                        radius: 15,
                        animating: true,
                      ),
                    ],
                  )
                : Expanded(
                    child: SizedBox(
                      width: Scaler.width(1, context),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ScrollConfiguration(
                            behavior: RemoveGlow(),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: Scaler.width(0.85, context),
                                    child: Column(
                                      children: [
                                        BookThumbnail(
                                          imgUrl: bookInfo.thumbnail,
                                          width: 150,
                                          height: 216.67,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          bookInfo.title,
                                          style:
                                              TextStyles.bookDeatilTitleStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '저자 ',
                                              style: TextStyles
                                                  .bookDeatilAuthorStyle
                                                  .copyWith(
                                                color: ColorSet.grey,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: Scaler.width(
                                                        0.85, context) -
                                                    30,
                                              ),
                                              child: Text(
                                                bookInfo.authors.join(', '),
                                                style: TextStyles
                                                    .bookDeatilAuthorStyle,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  SizedBox(
                                    width: Scaler.width(0.85, context),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomButton(
                                          onPressed: () async {
                                            final response =
                                                await setBookLibrary(
                                              bookInfo.bookUuid,
                                              'BEFORE',
                                            );
                                            showModal(
                                              context,
                                              RegisterBookLibraryConfirm(
                                                result: response,
                                                state: 'BEFORE',
                                              ),
                                              false,
                                            );
                                          },
                                          width: Scaler.width(0.41, context),
                                          height: 48,
                                          borderRadius: 12,
                                          color: ColorSet.superLightGrey,
                                          borderColor: ColorSet.superLightGrey,
                                          child: Text(
                                            '읽을 예정이에요',
                                            style: TextStyles
                                                .bookDetailButtonStyle
                                                .copyWith(
                                              color: ColorSet.darkGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        CustomButton(
                                          onPressed: () async {
                                            final response =
                                                await setBookLibrary(
                                              bookInfo.bookUuid,
                                              'AFTER',
                                            );
                                            showModal(
                                              context,
                                              RegisterBookLibraryConfirm(
                                                result: response,
                                                state: 'AFTER',
                                              ),
                                              false,
                                            );
                                          },
                                          width: Scaler.width(0.41, context),
                                          height: 48,
                                          borderRadius: 12,
                                          color: ColorSet.superLightGrey,
                                          borderColor: ColorSet.superLightGrey,
                                          child: Text(
                                            '이미 읽었어요',
                                            style: TextStyles
                                                .bookDetailButtonStyle
                                                .copyWith(
                                              color: ColorSet.darkGrey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    width: Scaler.width(1, context),
                                    color: ColorSet.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 15,
                                    ),
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: Scaler.width(0.85, context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '도서 정보',
                                            style: TextStyles
                                                .bookDeatilSubTitleStyle,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '출판사 ',
                                                style: TextStyles
                                                    .bookDeatilLabelStyle,
                                              ),
                                              Text(
                                                bookInfo.publisher,
                                                style: TextStyles
                                                    .bookDeatilLabelStyle
                                                    .copyWith(
                                                  color: ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                '출판일 ',
                                                style: TextStyles
                                                    .bookDeatilLabelStyle,
                                              ),
                                              Text(
                                                bookInfo.publishedAt.length > 9
                                                    ? bookInfo.publishedAt
                                                        .substring(0, 10)
                                                    : bookInfo.publishedAt,
                                                style: TextStyles
                                                    .bookDeatilLabelStyle
                                                    .copyWith(
                                                  color: ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'ISBN ',
                                                style: TextStyles
                                                    .bookDeatilLabelStyle,
                                              ),
                                              Text(
                                                bookInfo.isbn
                                                    .trim()
                                                    .split(' ')[0],
                                                style: TextStyles
                                                    .bookDeatilLabelStyle
                                                    .copyWith(
                                                  color: ColorSet.semiDarkGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: Scaler.width(1, context),
                                    color: ColorSet.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 15,
                                    ),
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: Scaler.width(0.85, context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '리뷰',
                                            style: TextStyles
                                                .bookDeatilSubTitleStyle,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  StarRowWidget(
                                                    star: bookInfo.star,
                                                    size: 18,
                                                    gap: 5,
                                                  ),
                                                  const SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    '(${bookInfo.star.toString().substring(0, 3)}/5.0)',
                                                    style: TextStyles
                                                        .bookDeatilReviewScoreStyle,
                                                  ),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    RouteName.review,
                                                    arguments:
                                                        bookInfo.bookUuid,
                                                  );
                                                },
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                child: Text(
                                                  '모두 보기 (${bookInfo.starCount}) >',
                                                  style: TextStyles
                                                      .bookDeatilReviewScoreStyle
                                                      .copyWith(
                                                          color: ColorSet
                                                              .semiDarkGrey,
                                                          letterSpacing: -0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: Scaler.width(1, context),
                                    color: ColorSet.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 15,
                                    ),
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: Scaler.width(0.85, context),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '도서 소개',
                                            style: TextStyles
                                                .bookDeatilSubTitleStyle,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            bookInfo.content.isNotEmpty
                                                ? '${bookInfo.content} ...'
                                                : '도서 소개가 없습니다',
                                            style: TextStyles
                                                .bookDeatilContentStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await launchUrl(
                                          Uri.parse(bookInfo.searchUrl));
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: Container(
                                      width: Scaler.width(0.85, context),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 21,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3D3D3D),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/daum_logo.png',
                                                height: 22,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                'assets/images/kakao_text_logo.png',
                                                height: 18,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '상세 정보 검색  >',
                                            style: TextStyles
                                                .bookDeatilLabelStyle
                                                .copyWith(
                                              color: ColorSet.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            bottom: _showButton ? 10.0 : -60.0,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RouteName.recordSetting,
                                  arguments: bookInfo.bookUuid,
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 23,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorSet.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(28),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorSet.primary.withOpacity(0.3),
                                      spreadRadius: 0,
                                      blurRadius: 4,
                                      offset: const Offset(
                                        0,
                                        4,
                                      ), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      '독서 시작하기',
                                      style: TextStyles.bookDetailButtonStyle,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(
                                      'assets/images/white_right_arrow.svg',
                                      width: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
