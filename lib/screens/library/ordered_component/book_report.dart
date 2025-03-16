import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/widgets/report_card_widget.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '독후감',
                style: TextStyles.myLibrarySubTitleStyle,
              ),
              InkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.libraryReportShowMore,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  Navigator.pushNamed(
                    context,
                    RouteName.libraryReportListScreen,
                  );
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '모두보기',
                      style: TextStyles.myLibraryShowMoreStyle,
                    ),
                    Transform.rotate(
                      angle: 270 * math.pi / 180,
                      child: SvgPicture.asset(
                        'assets/images/show_more_grey.svg',
                        width: 21,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        bookReportInfoList.isNotEmpty
            ? SizedBox(
                width: Scaler.width(1, context),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: bookReportInfoList.length > 5
                          ? 5
                          : bookReportInfoList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ReportCardWidget(
                              bookUuid: bookReportInfoList[index].bookUuid,
                              reportUuid:
                                  bookReportInfoList[index].bookReportUuid,
                              createdAt: bookReportInfoList[index].createdAt,
                              report: bookReportInfoList[index].report,
                            ),
                            index != bookReportInfoList.length - 1
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
              )
            : Container(
                width: Scaler.width(0.85, context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorSet.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: Scaler.width(0.85, context),
                  height: 35,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '독후감이 아직 없어요 📑',
                          style: TextStyles.questButtonStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
