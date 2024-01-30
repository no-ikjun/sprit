import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/widgets/book_mark_widget.dart';
import 'package:sprit/screens/library/widgets/my_book_info.dart';

Future<BookMarkCallback> getBookMark(BuildContext context, int page) async {
  return await BookLibraryService.getBookMark(context, page);
}

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  List<BookMarkInfo> bookMarkInfoList = [];
  bool bookMarkMoreAvailable = false;

  List<BookReportInfo> bookReportInfoList = [];
  int reportCurrent = 0;

  @override
  void initState() {
    super.initState();
    getBookMark(context, 1).then((value) {
      setState(() {
        bookMarkInfoList = value.bookMarkInfoList;
        bookMarkMoreAvailable = value.moreAvailable;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bookMarkInfoList.isNotEmpty
                          ? BookMarkWidget(
                              bookUuid: bookMarkInfoList[0].bookUuid,
                              thumbnail: bookMarkInfoList[0].thumbnail,
                              lastPage: bookMarkInfoList[0].lastPage)
                          : Container(),
                      bookMarkInfoList.length > 1
                          ? BookMarkWidget(
                              bookUuid: bookMarkInfoList[1].bookUuid,
                              thumbnail: bookMarkInfoList[1].thumbnail,
                              lastPage: bookMarkInfoList[1].lastPage)
                          : Container(),
                      bookMarkInfoList.length > 2
                          ? BookMarkWidget(
                              bookUuid: bookMarkInfoList[2].bookUuid,
                              thumbnail: bookMarkInfoList[2].thumbnail,
                              lastPage: bookMarkInfoList[2].lastPage)
                          : Container(),
                    ],
                  ),
                ),
                bookMarkMoreAvailable
                    ? Column(
                        children: [
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
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              height: 35,
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
                      const MyBookInfoWidget(
                        bookUuid: 'BO03f10f-240108-fc15e250',
                        count: 0,
                        state: 'BEFORE',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const MyBookInfoWidget(
                        bookUuid: 'BO03f10f-240108-fc15e250',
                        count: 0,
                        state: 'AFTER',
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const MyBookInfoWidget(
                        bookUuid: 'BO03f10f-240108-fc15e250',
                        count: 0,
                        state: 'READING',
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
              height: 35,
            ),
            Column(
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '저장된 문구 (스크랩)',
                        style: TextStyles.myLibrarySubTitleStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Column(
                    children: [
                      // LibraryPhraseWidget(),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      // LibraryPhraseWidget(),
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
              height: 35,
            ),
            Column(
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '내가 작성한 독후감',
                        style: TextStyles.myLibrarySubTitleStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: Scaler.width(1, context),
                  child: CarouselSlider.builder(
                    itemCount: bookReportInfoList.length,
                    options: CarouselOptions(
                      viewportFraction: 0.87,
                      aspectRatio: Scaler.width(0.85, context) / 55,
                      autoPlay: false,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) => {
                        setState(() {
                          reportCurrent = index;
                        })
                      },
                    ),
                    itemBuilder: (context, index, realIndex) => Container(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: reportCurrent == 0
                            ? ColorSet.lightGrey
                            : ColorSet.lightGrey.withOpacity(0.3),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 35,
            ),
          ],
        ),
      ),
    );
  }
}
