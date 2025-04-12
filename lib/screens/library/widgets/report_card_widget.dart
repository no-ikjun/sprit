import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/book_thumbnail.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

Future<BookInfo> getBookInfoByUuid(
  BuildContext context,
  String bookUuid,
) async {
  return await BookInfoService.getBookInfoByUuid(context, bookUuid);
}

class ReportCardWidget extends StatefulWidget {
  final String bookUuid;
  final String reportUuid;
  final String createdAt;
  final String report;

  const ReportCardWidget({
    super.key,
    required this.bookUuid,
    required this.reportUuid,
    required this.createdAt,
    required this.report,
  });

  @override
  State<ReportCardWidget> createState() => _ReportCardWidgetState();
}

class _ReportCardWidgetState extends State<ReportCardWidget> {
  String bookTitle = '';
  String thumbnail = '';

  @override
  void initState() {
    super.initState();
    getBookInfoByUuid(context, widget.bookUuid).then((value) {
      setState(() {
        bookTitle = value.title;
        thumbnail = value.thumbnail;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScalableInkWell(
      onTap: () {
        AmplitudeService().logEvent(
          AmplitudeEvent.libraryReportDetailClick,
          properties: {
            'userUuid': context.read<UserInfoState>().userInfo.userUuid,
            'bookUuid': widget.bookUuid,
            'bookReportUuid': widget.reportUuid,
          },
        );
        Navigator.pushNamed(
          context,
          RouteName.bookReport,
          arguments: widget.reportUuid,
        );
      },
      child: Container(
        width: Scaler.width(0.85, context),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorSet.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 0),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Scaler.width(0.7, context),
              child: Row(
                children: [
                  BookThumbnail(
                    imgUrl: thumbnail,
                    width: 34.62,
                    height: 50,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: Scaler.width(0.6, context) - 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookTitle,
                          style: TextStyles.myLibraryBookReportTitleStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.createdAt.substring(0, 10),
                          style: TextStyles.myLibraryBookReportDateStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/right_arrow_grey.svg',
                  width: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
