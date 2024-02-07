import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/widgets/book_mark_widget.dart';

Future<BookMarkCallback> getBookMark(BuildContext context, int page) async {
  return await BookLibraryService.getBookMark(context, page);
}

class BookMarkComponent extends StatefulWidget {
  const BookMarkComponent({super.key});

  @override
  State<BookMarkComponent> createState() => _BookMarkComponentState();
}

class _BookMarkComponentState extends State<BookMarkComponent> {
  List<BookMarkInfo> bookMarkInfoList = [];
  bool bookMarkMoreAvailable = false;
  int bookMarkCurrentPage = 1;

  void _initialize() async {
    await getBookMark(context, bookMarkCurrentPage).then((value) {
      setState(() {
        bookMarkInfoList = value.bookMarkInfoList;
        bookMarkMoreAvailable = value.moreAvailable;
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
          child: Column(
            children: List.generate(
              ((bookMarkInfoList.length - 1) ~/ 3 + 1),
              (index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index2) {
                        index2 += index * 3;
                        if (index2 < bookMarkInfoList.length) {
                          return BookMarkWidget(
                            bookUuid: bookMarkInfoList[index2].bookUuid,
                            thumbnail: bookMarkInfoList[index2].thumbnail,
                            lastPage: bookMarkInfoList[index2].lastPage,
                          );
                        } else {
                          return SizedBox(
                            width: Scaler.width(0.25, context),
                          );
                        }
                      }),
                    ),
                    index != ((bookMarkInfoList.length - 1) ~/ 3)
                        ? const SizedBox(
                            height: 12,
                          )
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ),
        bookMarkMoreAvailable
            ? Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      await getBookMark(
                        context,
                        bookMarkCurrentPage + 1,
                      ).then((value) {
                        setState(() {
                          bookMarkInfoList.addAll(value.bookMarkInfoList);
                          bookMarkMoreAvailable = value.moreAvailable;
                          bookMarkCurrentPage++;
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
            : bookMarkInfoList.length > 3
                ? Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          setState(() {
                            bookMarkInfoList = bookMarkInfoList.sublist(0, 3);
                            bookMarkMoreAvailable = true;
                            bookMarkCurrentPage = 1;
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
    );
  }
}
