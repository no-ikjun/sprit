import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/ordered_component/book_mark.dart';
import 'package:sprit/screens/library/ordered_component/my_book_info.dart';
import 'package:sprit/screens/library/widgets/library_phrase_widget.dart';

Future<PhraseLibraryListCallback> getPhraseForLibrary(
  BuildContext context,
  int page,
) async {
  return await PhraseService.getPhraseForLibrary(context, page);
}

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  List<PhraseLibraryType> phraseInfoList = [];
  bool phraseMoreAvailable = false;
  int phraseCurrentPage = 1;

  List<BookReportInfo> bookReportInfoList = [];
  int reportCurrent = 0;

  void _initialize() async {
    await getPhraseForLibrary(context, phraseCurrentPage).then((value) {
      debugPrint(value.phraseLibraryList.length.toString());
      setState(() {
        phraseInfoList = value.phraseLibraryList;
        phraseMoreAvailable = value.moreAvailable;
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
                  child: ListView.builder(
                    itemCount: phraseInfoList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          LibraryPhraseWidget(
                            phraseUuid: phraseInfoList[index].phraseUuid,
                            phrase: phraseInfoList[index].phrase,
                            bookTitle: phraseInfoList[index].bookTitle,
                          ),
                          index != phraseInfoList.length - 1
                              ? const SizedBox(
                                  height: 8,
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
                phraseMoreAvailable
                    ? Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () async {
                              await getPhraseForLibrary(
                                context,
                                phraseCurrentPage + 1,
                              ).then((value) {
                                setState(() {
                                  phraseInfoList
                                      .addAll(value.phraseLibraryList);
                                  phraseMoreAvailable = value.moreAvailable;
                                  phraseCurrentPage++;
                                });
                              });
                            },
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '더보기',
                                  style: TextStyles.myLibraryShowMoreStyle,
                                ),
                                SvgPicture.asset(
                                  'assets/images/arrow_right.svg',
                                  width: 12,
                                ),
                              ],
                            ),
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
