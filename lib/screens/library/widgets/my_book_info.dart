import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/popups/library/book_state.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

Future<BookInfo> getBookInfo(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class MyBookInfoWidget extends StatefulWidget {
  final String bookUuid;
  final int count;
  final String state;
  final Function callback;
  const MyBookInfoWidget({
    super.key,
    required this.bookUuid,
    required this.count,
    required this.state,
    required this.callback,
  });

  @override
  State<MyBookInfoWidget> createState() => _MyBookInfoWidgetState();
}

class _MyBookInfoWidgetState extends State<MyBookInfoWidget> {
  bool isLoading = false;
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
  );

  Future<void> _getBookInfo() async {
    setState(() {
      isLoading = true;
    });
    await getBookInfo(context, widget.bookUuid).then((value) {
      setState(() {
        bookInfo = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getBookInfo();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: Scaler.width(0.85, context),
            height: 110,
            child: const CupertinoActivityIndicator(
              radius: 15,
              animating: true,
            ),
          )
        : Row(
            children: [
              BookThumbnail(
                imgUrl: bookInfo.thumbnail,
                width: 76.15,
                height: 110,
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: Scaler.width(0.85, context) - 30 - 76.15 - 15,
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookInfo.title,
                          style: TextStyles.myLibraryBookTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${bookInfo.authors[0]} ${bookInfo.publisher.isNotEmpty ? '· ${bookInfo.publisher}' : ''}',
                          style: TextStyles.myLibraryBookAuthorStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '독서 기록 ${widget.count.toString()}개',
                          style: TextStyles.myLibraryBookRecordCountStyle,
                        ),
                        InkWell(
                          onTap: () {
                            AmplitudeService().logEvent(
                              AmplitudeEvent.libraryMyBookChoice,
                              context.read<UserInfoState>().userInfo.userUuid,
                              eventProperties: {
                                'bookUuid': bookInfo.bookUuid,
                                'bookTitle': bookInfo.title,
                                'bookState': widget.state,
                              },
                            );
                            showModal(
                              context,
                              BookStateChange(
                                bookTitle: bookInfo.title,
                                bookUuid: bookInfo.bookUuid,
                                callback: widget.callback,
                              ),
                              false,
                            );
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: (widget.state == 'READING')
                                  ? ColorSet.primaryLight
                                  : (widget.state == 'AFTER')
                                      ? ColorSet.lightGrey
                                      : GrassColor.grassDefault,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (widget.state == 'READING')
                                      ? '읽는 중'
                                      : (widget.state == 'AFTER')
                                          ? '독서 완료'
                                          : '읽을 책',
                                  style: TextStyles
                                      .myLibraryBookRecordStateStyle
                                      .copyWith(
                                    color: (widget.state == 'READING')
                                        ? ColorSet.white
                                        : (widget.state == 'AFTER')
                                            ? ColorSet.white
                                            : ColorSet.darkGrey,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                SvgPicture.asset(
                                  (widget.state == 'READING' ||
                                          widget.state == 'AFTER')
                                      ? 'assets/images/show_more_white.svg'
                                      : 'assets/images/show_more_semi_dark_grey.svg',
                                  width: 21,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
