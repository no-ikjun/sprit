import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/screens/library/widgets/report_card_widget.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<List<BookReportInfo>> getReportList(BuildContext context) async {
  return BookReportService.getBookReportByUserUuid(context);
}

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  List<BookReportInfo> bookReportList = [];
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;

  void _initialize() async {
    setState(() {
      isLoading = true;
    });
    await getReportList(context).then((value) {
      setState(() {
        bookReportList = value;
        isLoading = false;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              label: '독후감',
            ),
            isLoading
                ? const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CupertinoActivityIndicator(
                        radius: 16,
                        animating: true,
                      ),
                    ],
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Column(
                          children: [
                            ListView.builder(
                              itemCount: bookReportList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ReportCardWidget(
                                      bookUuid: bookReportList[index].bookUuid,
                                      reportUuid:
                                          bookReportList[index].bookReportUuid,
                                      createdAt:
                                          bookReportList[index].createdAt,
                                      report: bookReportList[index].report,
                                    ),
                                    index != bookReportList.length - 1
                                        ? const SizedBox(
                                            height: 8,
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
