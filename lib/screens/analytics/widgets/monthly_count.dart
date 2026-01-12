import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/record.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

String getTitleByKind(String kind) {
  switch (kind) {
    case 'COUNT':
      return '독서 기록 수';
    case 'GOAL':
      return '목표 달성 횟수';
    case 'BOOK':
      return '읽은 책';
    default:
      return '';
  }
}

String getMentByKind(String kind, int presentNumber, int pastNumber) {
  if (presentNumber > pastNumber) {
    switch (kind) {
      case 'COUNT':
        return '저번 달에 비해 독서 기록을 ${presentNumber - pastNumber}번 더 했어요! 👏';
      case 'GOAL':
        return '저번 달보다 독서 목표 달성 횟수가 ${presentNumber - pastNumber}번 늘었어요! 🎉';
      case 'BOOK':
        return '저번 달보다 책을${presentNumber - pastNumber}권 더 읽고있어요! 👍';
      default:
        return '';
    }
  } else if (presentNumber < pastNumber) {
    switch (kind) {
      case 'COUNT':
        return '저번 달에는 독서 기록을 $pastNumber번 했었어요 📚';
      case 'GOAL':
        return '저번 달에는 $pastNumber번 목표를 달성했었어요 🔖';
      case 'BOOK':
        return '저번 달보다 책을${pastNumber - presentNumber}권 덜 읽고있어요 📘';
      default:
        return '';
    }
  } else {
    switch (kind) {
      case 'COUNT':
        return '저번 달과 독서 기록 수가 같아요';
      case 'GOAL':
        return '저번 달과독서 목표 달성 횟수가 같아요';
      case 'BOOK':
        return '저번 달과 읽은 책 수가 같아요';
      default:
        return '';
    }
  }
}

String getCountString(String kind, int presentNumber) {
  switch (kind) {
    case 'COUNT':
      return '$presentNumber개';
    case 'GOAL':
      return '$presentNumber회';
    case 'BOOK':
      return '$presentNumber권';
    default:
      return '';
  }
}

Future<MonthlyRecordInfo> getMonthlyRecord(
  BuildContext context,
  int year,
  int month,
  String kind,
) async {
  try {
    return await RecordService.getMonthlyRecord(year, month, kind);
  } catch (e) {
    return const MonthlyRecordInfo(
      presentMonth: 0,
      pastMonth: 0,
    );
  }
}

class MonthlyCount extends StatefulWidget {
  final String kind;
  const MonthlyCount({super.key, required this.kind});

  @override
  State<MonthlyCount> createState() => _MonthlyCountState();
}

class _MonthlyCountState extends State<MonthlyCount> {
  MonthlyRecordInfo monthlyRecord = const MonthlyRecordInfo(
    presentMonth: 0,
    pastMonth: 0,
  );

  @override
  void initState() {
    getMonthlyRecord(context, 2024, 2, widget.kind).then((value) {
      setState(() {
        monthlyRecord = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          width: Scaler.width(0.85, context),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getTitleByKind(widget.kind),
                style: TextStyles.analyticsMonthlyReportTitleStyle,
              ),
              Row(
                children: [
                  Text(
                    getCountString(widget.kind, monthlyRecord.presentMonth),
                    style: TextStyles.analyticsMonthlyReportDataStyle,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  monthlyRecord.presentMonth != monthlyRecord.pastMonth
                      ? Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          decoration: BoxDecoration(
                            color: monthlyRecord.presentMonth >
                                    monthlyRecord.pastMonth
                                ? ColorSet.green.withOpacity(0.3)
                                : ColorSet.red.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                monthlyRecord.presentMonth >
                                        monthlyRecord.pastMonth
                                    ? 'assets/images/up_icon_green.svg'
                                    : 'assets/images/down_icon_red.svg',
                                width: 18,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                '${getCountString(widget.kind, (monthlyRecord.presentMonth - monthlyRecord.pastMonth).abs())} ',
                                style: TextStyles
                                    .analyticsMonthlyReportAmountStyle
                                    .copyWith(
                                  color: monthlyRecord.presentMonth >
                                          monthlyRecord.pastMonth
                                      ? ColorSet.green
                                      : ColorSet.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
              Text(
                getMentByKind(
                  widget.kind,
                  monthlyRecord.presentMonth,
                  monthlyRecord.pastMonth,
                ),
                style: TextStyles.analyticsMonthlyReportMentStyle,
              )
            ],
          ),
        ),
      ],
    );
  }
}
