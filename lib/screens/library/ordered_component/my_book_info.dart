import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/widgets/my_book_info.dart';

Future<BookLibraryByStateListCallback> getBookLibraryByState(
  BuildContext context,
  List<String> stateList,
  int page,
) async {
  return await BookLibraryService.getBookLibraryByState(
    context,
    stateList,
    page,
  );
}

class MyBookInfoComponent extends StatefulWidget {
  const MyBookInfoComponent({super.key});

  @override
  State<MyBookInfoComponent> createState() => _MyBookInfoComponentState();
}

class _MyBookInfoComponentState extends State<MyBookInfoComponent> {
  List<String> bookLibraryByStateListStateList = ["READING", "AFTER"];
  List<BookLibraryByStateList> bookLibraryByStateList = [];
  bool bookLibraryByStateListMoreAvailable = false;
  int bookLibraryByStateListCurrentPage = 1;

  void _initialize() async {
    await getBookLibraryByState(
      context,
      bookLibraryByStateListStateList,
      bookLibraryByStateListCurrentPage,
    ).then((value) {
      setState(() {
        bookLibraryByStateList = value.bookLibraryByStateList;
        bookLibraryByStateListMoreAvailable = value.moreAvailable;
      });
    });
  }

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              ListView.builder(
                itemCount: bookLibraryByStateList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      MyBookInfoWidget(
                        bookUuid: bookLibraryByStateList[index].bookUuid,
                        count: bookLibraryByStateList[index].count,
                        state: bookLibraryByStateList[index].state,
                      ),
                      index != bookLibraryByStateList.length - 1
                          ? const SizedBox(
                              height: 12,
                            )
                          : Container(),
                    ],
                  );
                },
              ),
              bookLibraryByStateListMoreAvailable
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            await getBookLibraryByState(
                              context,
                              bookLibraryByStateListStateList,
                              bookLibraryByStateListCurrentPage + 1,
                            ).then((value) {
                              setState(() {
                                bookLibraryByStateList
                                    .addAll(value.bookLibraryByStateList);
                                bookLibraryByStateListMoreAvailable =
                                    value.moreAvailable;
                                bookLibraryByStateListCurrentPage++;
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
                                'assets/images/show_more_grey.svg',
                                width: 21,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : bookLibraryByStateList.length > 3
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  bookLibraryByStateList =
                                      bookLibraryByStateList.sublist(0, 3);
                                  bookLibraryByStateListMoreAvailable = true;
                                  bookLibraryByStateListCurrentPage = 1;
                                });
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '숨기기',
                                    style: TextStyles.myLibraryShowMoreStyle,
                                  ),
                                  Transform.rotate(
                                    angle: 180 * math.pi / 180,
                                    child: SvgPicture.asset(
                                      'assets/images/show_more_grey.svg',
                                      width: 21,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
