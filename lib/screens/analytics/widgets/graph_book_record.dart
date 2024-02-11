import 'package:flutter/cupertino.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/widgets/book_thumbnail.dart';

class GraphBookRecord extends StatefulWidget {
  final String bookUuid;
  final bool goalAchieved;
  final int totalTime;
  final int dailyTotalTime;
  const GraphBookRecord({
    super.key,
    required this.bookUuid,
    required this.goalAchieved,
    required this.totalTime,
    required this.dailyTotalTime,
  });

  @override
  State<GraphBookRecord> createState() => _GraphBookRecordState();
}

class _GraphBookRecordState extends State<GraphBookRecord> {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    BookInfoService.getBookInfoByUuid(context, widget.bookUuid).then((value) {
      setState(() {
        bookInfo = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? const SizedBox(
                height: 80,
                child: Center(
                  child: CupertinoActivityIndicator(
                    radius: 10,
                    animating: true,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BookThumbnail(
                    imgUrl: bookInfo.thumbnail,
                    width: 55.38,
                    height: 80,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: widget.goalAchieved
                                        ? ColorSet.green
                                        : ColorSet.red,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Scaler.width(0.85, context) -
                                      30 -
                                      55.38 -
                                      15 -
                                      11,
                                  child: Text(
                                    bookInfo.title,
                                    style:
                                        TextStyles.analyticsGraphBookTitleStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${bookInfo.authors.isNotEmpty ? bookInfo.authors[0] : ''} · ${bookInfo.publisher}',
                              style: TextStyles.analyticsGraphBookAuthorStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Scaler.width(0.85, context) - 30 - 55.38 - 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: (Scaler.width(0.85, context) -
                                        30 -
                                        55.38 -
                                        15) *
                                    (widget.totalTime / widget.dailyTotalTime),
                                height: 5,
                                decoration: BoxDecoration(
                                  color: ColorSet.superLightGrey,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              Text(
                                getFormattedTimeWithUnit(widget.totalTime),
                                style: TextStyles.analyticsGraphBookTimeStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
