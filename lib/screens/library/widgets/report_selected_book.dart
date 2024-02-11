import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class ReportSelectedBook extends StatefulWidget {
  final String bookUuid;
  const ReportSelectedBook({super.key, required this.bookUuid});

  @override
  State<ReportSelectedBook> createState() => _ReportSelectedBookState();
}

class _ReportSelectedBookState extends State<ReportSelectedBook> {
  bool isLoading = false;
  BookInfo selectedBookInfo = const BookInfo(
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

  @override
  void initState() {
    super.initState();
    getBookInfoByUuid(context, widget.bookUuid).then((value) {
      setState(() {
        selectedBookInfo = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Scaler.width(0.85, context),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorSet.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: isLoading
          ? const SizedBox(
              height: 110,
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: 15,
                  animating: true,
                ),
              ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BookThumbnail(
                  imgUrl: selectedBookInfo.thumbnail,
                  width: 76.15,
                  height: 110,
                ),
                const SizedBox(
                  width: 12,
                ),
                SizedBox(
                  height: 110,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Scaler.width(0.85, context) - 118.15,
                        child: Text(
                          selectedBookInfo.title,
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
                              Text(
                                selectedBookInfo.authors.isNotEmpty
                                    ? selectedBookInfo.authors[0]
                                    : '',
                                style:
                                    TextStyles.readBookSelectedDescriptionStyle,
                              ),
                              selectedBookInfo.translators.isNotEmpty
                                  ? Text(
                                      ' 번역 ',
                                      style: TextStyles
                                          .readBookSelectedDescriptionStyle
                                          .copyWith(
                                        color: ColorSet.grey,
                                      ),
                                    )
                                  : const SizedBox(),
                              selectedBookInfo.translators.isNotEmpty
                                  ? Text(
                                      selectedBookInfo.translators[0],
                                      style: TextStyles
                                          .readBookSelectedDescriptionStyle,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context) - 118.15,
                            child: Text(
                              '${selectedBookInfo.publisher} · ${(selectedBookInfo.publishedAt.length > 9) ? selectedBookInfo.publishedAt.substring(0, 10) : selectedBookInfo.publishedAt}',
                              style: TextStyles.readBookSelectedDescriptionStyle
                                  .copyWith(
                                color: ColorSet.grey,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
