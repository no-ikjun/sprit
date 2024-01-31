import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/ordered_component/book_mark.dart';
import 'package:sprit/screens/library/ordered_component/my_book_info.dart';
import 'package:sprit/screens/library/ordered_component/phrase_info.dart';

Future<List<BookReportInfo>> getBookReportByUserUuid(
  BuildContext context,
) async {
  return BookReportService.getBookReportByUserUuid(context);
}

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  List<BookReportInfo> bookReportInfoList = [];
  int reportCurrent = 0;

  void _initialize() async {
    await getBookReportByUserUuid(context).then((value) {
      debugPrint(value.length.toString());
      setState(() {
        bookReportInfoList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initialize();
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
            const BookMarkComponent(),
            const SizedBox(
              height: 35,
            ),
            const MyBookInfoComponent(),
            const SizedBox(
              height: 35,
            ),
            const MyPhraseComponent(),
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
                      autoPlay: false,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) => {
                        setState(() {
                          reportCurrent = index;
                        })
                      },
                    ),
                    itemBuilder: (context, index, realIndex) => Container(
                      width: Scaler.width(0.85, context),
                      height: 296,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '책 제목',
                                style: TextStyles.myLibraryBookReportTitleStyle,
                              ),
                              Text(
                                bookReportInfoList[index]
                                    .createdAt
                                    .substring(0, 10),
                                style: TextStyles.myLibraryBookReportDateStyle,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            height: 142,
                            child: Text(
                              bookReportInfoList[index].report,
                              style: TextStyles.myLibraryBookReportStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 6,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '자세히 보기',
                                  style:
                                      TextStyles.myLibraryBookReportButtonStyle,
                                ),
                                SvgPicture.asset(
                                  'assets/images/right_arrow_grey.svg',
                                  width: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    bookReportInfoList.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: reportCurrent == index
                            ? ColorSet.primary
                            : ColorSet.lightGrey,
                      ),
                    ),
                  ),
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
