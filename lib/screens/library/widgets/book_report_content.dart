import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class BookReportContent extends StatefulWidget {
  final String bookUuid;
  final String reportUuid;
  final String createdAt;
  final String report;
  const BookReportContent({
    super.key,
    required this.bookUuid,
    required this.reportUuid,
    required this.createdAt,
    required this.report,
  });

  @override
  State<BookReportContent> createState() => _BookReportContentState();
}

class _BookReportContentState extends State<BookReportContent> {
  String bookTitle = '';

  @override
  void initState() {
    super.initState();
    getBookInfoByUuid(context, widget.bookUuid).then((value) {
      setState(() {
        bookTitle = value.title;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Scaler.width(0.5, context),
              child: Text(
                bookTitle,
                style: TextStyles.myLibraryBookReportTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              widget.createdAt.substring(0, 10),
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
            widget.report,
            style: TextStyles.myLibraryBookReportStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteName.bookReport,
              arguments: widget.reportUuid,
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '자세히 보기',
                style: TextStyles.myLibraryBookReportButtonStyle,
              ),
              SvgPicture.asset(
                'assets/images/right_arrow_grey.svg',
                width: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
