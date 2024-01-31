import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/library/widgets/book_report_content.dart';

Future<List<BookReportInfo>> getBookReportByUserUuid(
  BuildContext context,
) async {
  return BookReportService.getBookReportByUserUuid(context);
}

class MyBookReportComponent extends StatefulWidget {
  const MyBookReportComponent({super.key});

  @override
  State<MyBookReportComponent> createState() => _MyBookReportComponentState();
}

class _MyBookReportComponentState extends State<MyBookReportComponent> {
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
    return Column(
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
              child: BookReportContent(
                bookUuid: bookReportInfoList[index].bookUuid,
                reportUuid: bookReportInfoList[index].bookReportUuid,
                report: bookReportInfoList[index].report,
                createdAt: bookReportInfoList[index].createdAt,
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
    );
  }
}
