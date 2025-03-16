import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book_library.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/read/review.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/read/widgets/book_report_modal.dart';
import 'package:sprit/screens/read/widgets/record_share_modal.dart';
import 'package:sprit/screens/read/widgets/selected_book.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<void> updateBookLibraryState(
  BuildContext context,
  String bookUuid,
  String state,
) async {
  await BookLibraryService.updateBookLibrary(context, bookUuid, state);
}

class ReadCompleteScreen extends StatefulWidget {
  final int goalAmount;
  const ReadCompleteScreen({super.key, required this.goalAmount});

  @override
  State<ReadCompleteScreen> createState() => _ReadCompleteScreenState();
}

String _formatTime(int adjustedSeconds) {
  if (adjustedSeconds == 0) {
    return '0초';
  }
  int hours = adjustedSeconds ~/ 3600;
  int remainingSeconds = adjustedSeconds % 3600;
  int minutes = remainingSeconds ~/ 60;
  int seconds = remainingSeconds % 60;
  if (adjustedSeconds >= 3600) {
    return '$hours시간 $minutes분';
  } else if (adjustedSeconds < 60) {
    return '$seconds초';
  } else {
    return '$minutes분 $seconds초';
  }
}

class _ReadCompleteScreenState extends State<ReadCompleteScreen> {
  void _showReportModal(
    BuildContext context,
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
        return BookReportModal(
          bookUuid: context
              .read<SelectedBookInfoState>()
              .getSelectedBookInfo
              .bookUuid,
        );
      },
    );
  }

  void _showShareModal(
    BuildContext context,
    String amount,
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
        return RecordShareModal(
          amount: amount,
        );
      },
    );
  }

  bool ischecked = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        body: SafeArea(
          maintainBottomViewPadding: false,
          child: Column(
            children: [
              const CustomAppBar(
                label: '독서 기록',
                onlyLabel: true,
              ),
              const SelectedBook(
                padding: 10,
                isLoading: false,
              ),
              SizedBox(
                height: Scaler.height(0.03, context),
              ),
              const Text(
                '독서 완료 👏',
                style: TextStyles.readRecordTitleStyle,
              ),
              SizedBox(
                height: Scaler.height(0.01, context),
              ),
              (context
                          .read<SelectedRecordInfoState>()
                          .getSelectedRecordInfo
                          .goalType ==
                      'TIME')
                  ? Text(
                      '총 ${_formatTime(widget.goalAmount)}간 독서했어요',
                      style: TextStyles.readRecordDescriptionStyle,
                    )
                  : Text(
                      '총 ${widget.goalAmount}페이지만큼 독서했어요',
                      style: TextStyles.readRecordDescriptionStyle,
                    ),
              SizedBox(
                height: Scaler.height(0.025, context),
              ),
              context
                      .read<SelectedRecordInfoState>()
                      .getSelectedRecordInfo
                      .goalAchieved
                  ? SvgPicture.asset(
                      'assets/images/read_complete_badge.svg',
                      width: Scaler.width(0.38, context),
                    )
                  : SvgPicture.asset(
                      'assets/images/read_fail_badge.svg',
                      width: Scaler.width(0.38, context),
                    ),
              SizedBox(
                height: Scaler.height(0.03, context),
              ),
              Text(
                context
                        .read<SelectedRecordInfoState>()
                        .getSelectedRecordInfo
                        .goalAchieved
                    ? '🎉 목표 독서량을 달성했어요!'
                    : '목표 독서량을 달성하지 못했어요 🥲',
                style: TextStyles.readRecordTitleStyle.copyWith(fontSize: 22),
              ),
              SizedBox(
                height: Scaler.height(0.02, context),
              ),
              InkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.recordCompleteButton,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  setState(() {
                    ischecked = !ischecked;
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '책을 끝까지 읽으셨나요?',
                      style: TextStyles.readRecordEndingTextButtonStyle,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SvgPicture.asset(
                      ischecked
                          ? 'assets/images/checkbox_blue.svg'
                          : 'assets/images/checkbox_grey.svg',
                      width: 25,
                    ),
                  ],
                ),
              ),
              ischecked
                  ? Column(
                      children: [
                        SizedBox(
                          height: Scaler.height(0.01, context),
                        ),
                        InkWell(
                          onTap: () {
                            AmplitudeService().logEvent(
                              AmplitudeEvent.recordAddReportButton,
                              context.read<UserInfoState>().userInfo.userUuid,
                            );
                            _showReportModal(
                              context,
                            );
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: ColorSet.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 0),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '독후감 쓰기',
                                  style: TextStyles.timerLeaveButtonStyle,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset(
                                  'assets/images/write_icon.svg',
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: Scaler.height(0.03, context),
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      width: Scaler.width(0.85, context) * 0.5 - 5,
                      height: 50,
                      color: ColorSet.lightGrey,
                      borderColor: ColorSet.lightGrey,
                      onPressed: () {
                        AmplitudeService().logEvent(
                          AmplitudeEvent.recordShareButton,
                          context.read<UserInfoState>().userInfo.userUuid,
                        );
                        _showShareModal(
                          context,
                          (context
                                      .read<SelectedRecordInfoState>()
                                      .getSelectedRecordInfo
                                      .goalType ==
                                  'TIME')
                              ? _formatTime(widget.goalAmount)
                              : '${widget.goalAmount}페이지',
                        );
                      },
                      child: const Text(
                        '공유하기',
                        style: TextStyles.buttonLabelStyle,
                      ),
                    ),
                    CustomButton(
                      width: Scaler.width(0.85, context) * 0.5 - 5,
                      height: 50,
                      onPressed: () async {
                        AmplitudeService().logEvent(
                          AmplitudeEvent.recordGoHome,
                          context.read<UserInfoState>().userInfo.userUuid,
                        );
                        if (ischecked) {
                          await updateBookLibraryState(
                            context,
                            context
                                .read<SelectedBookInfoState>()
                                .getSelectedBookInfo
                                .bookUuid,
                            'AFTER',
                          );
                        }
                        Navigator.pushReplacementNamed(
                          context,
                          RouteName.home,
                        );
                        if (ischecked) {
                          showModal(context, const ReviewModal(), false);
                        }
                        context
                            .read<SelectedRecordInfoState>()
                            .removeSelectedRecord();
                        context
                            .read<SelectedRecordInfoState>()
                            .removeSelectedRecord();
                      },
                      child:
                          const Text('홈으로', style: TextStyles.buttonLabelStyle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
