import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/widgets/book_report_edit.dart';
import 'package:sprit/screens/library/widgets/report_selected_book.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<BookReportInfo> getBookReportByUuid(
  BuildContext context,
  String reportUuid,
) async {
  return await BookReportService.getBookReportByBookReportUuid(
    context,
    reportUuid,
  );
}

void _showBottomModal(
  BuildContext context,
  String report,
  String reportUuid,
  Function callback,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    constraints: BoxConstraints(
      minWidth: Scaler.width(1, context),
    ),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    builder: (context) {
      return BookReportEdit(
        report: report,
        reportUuid: reportUuid,
        callback: callback,
      );
    },
  );
}

class BookReportScreen extends StatefulWidget {
  final String reportUuid;
  const BookReportScreen({super.key, required this.reportUuid});

  @override
  State<BookReportScreen> createState() => _BookReportScreenState();
}

class _BookReportScreenState extends State<BookReportScreen> {
  bool isLoading = false;
  BookReportInfo bookReportInfo = const BookReportInfo(
    bookReportUuid: '',
    bookUuid: '',
    userUuid: '',
    report: '',
    createdAt: '',
  );
  @override
  void initState() {
    super.initState();
    isLoading = true;
    getBookReportByUuid(context, widget.reportUuid).then((value) {
      setState(() {
        bookReportInfo = value;
        isLoading = false;
      });
    });
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
              label: '독후감',
            ),
            isLoading
                ? const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                        animating: true,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      isLoading
                          ? Container(
                              height: 140,
                            )
                          : ReportSelectedBook(
                              bookUuid: bookReportInfo.bookUuid),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          children: [
                            const Text(
                              '독후감 작성 시간',
                              style: TextStyles.myLibraryBookReportTimeStyle,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              getPastTime(bookReportInfo.createdAt),
                              style: TextStyles.myLibraryBookReportTimeStyle
                                  .copyWith(
                                color: ColorSet.semiDarkGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Text(
                          bookReportInfo.report,
                          style: TextStyles.myLibraryBookReportStyle,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          AmplitudeService().logEvent(
                            AmplitudeEvent.libraryReportDetailEdit,
                            properties: {
                              'userUuid': context
                                  .read<UserInfoState>()
                                  .userInfo
                                  .userUuid,
                              'bookReportUuid': bookReportInfo.bookReportUuid,
                              'bookUuid': bookReportInfo.bookUuid,
                            },
                          );
                          _showBottomModal(
                            context,
                            bookReportInfo.report,
                            bookReportInfo.bookReportUuid,
                            () {
                              getBookReportByUuid(context, widget.reportUuid)
                                  .then(
                                (value) {
                                  setState(() {
                                    bookReportInfo = value;
                                  });
                                },
                              );
                            },
                          );
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '수정하기',
                              style: TextStyles.myLibraryBookReportButtonStyle,
                            ),
                            SvgPicture.asset(
                              'assets/images/right_arrow_grey.svg',
                              width: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
