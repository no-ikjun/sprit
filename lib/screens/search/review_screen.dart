import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/apis/services/review.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/search/widgets/review_content.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/star_row.dart';

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String uuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, uuid);
}

Future<List<ReviewInfo>> getReviewByBookUuid(
  BuildContext context,
  String bookUuid,
) async {
  return await ReviewService().getReviewByBookUuid(context, bookUuid);
}

class ReviewScreen extends StatefulWidget {
  final String bookUuid;
  const ReviewScreen({super.key, required this.bookUuid});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
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
    star: 0,
    starCount: 0,
  );
  List<ReviewInfo> reviews = [];

  Future<void> _getInfo(BuildContext context, String bookUuid) async {
    setState(() {
      isLoading = true;
    });
    await getBookInfoByUuid(context, bookUuid).then((value) {
      setState(() {
        bookInfo = value;
      });
      getReviewByBookUuid(context, bookUuid).then((value) {
        setState(() {
          reviews = value;
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getInfo(context, widget.bookUuid);
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
              label: '리뷰',
            ),
            const SizedBox(
              height: 5,
            ),
            isLoading
                ? const Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      CupertinoActivityIndicator(
                        radius: 17,
                        animating: true,
                      )
                    ],
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookInfo.title,
                                  style: TextStyles.bookReviewTitleStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    StarRowWidget(star: bookInfo.star),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      bookInfo.star.toString().substring(0, 3),
                                      style: TextStyles.bookReviewCountStyle,
                                    ),
                                    Text(
                                      ' (${bookInfo.starCount})',
                                      style: TextStyles.bookReviewCountStyle
                                          .copyWith(
                                        color: ColorSet.grey,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: List.generate(
                              reviews.length,
                              (index) {
                                return ReviewContent(review: reviews[index]);
                              },
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
