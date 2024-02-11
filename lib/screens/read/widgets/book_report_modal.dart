import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/book_report.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<bool> setBookReport(
  BuildContext context,
  String bookUuid,
  String report,
) async {
  return await BookReportService.setNewBookReport(context, bookUuid, report);
}

class BookReportModal extends StatefulWidget {
  const BookReportModal({
    super.key,
    required this.textarea,
    required this.bookUuid,
  });

  final TextEditingController textarea;
  final String bookUuid;

  @override
  State<BookReportModal> createState() => _BookReportModalState();
}

class _BookReportModalState extends State<BookReportModal> {
  String bookReport = '';

  bool isLoading = false;
  bool isSubmitted = false;

  Future<void> submitBookReport() async {
    setState(() {
      isSubmitted = true;
      isLoading = true;
    });
    setBookReport(context, widget.bookUuid, bookReport).then((value) {
      if (value != false) {
        setState(() {
          isLoading = false;
        });
        Future.delayed(const Duration(milliseconds: 800), () {
          Navigator.pop(context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: isSubmitted
              ? SizedBox(
                  height: 200,
                  child: (!isLoading)
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Container(
                              width: 60,
                              height: 8,
                              decoration: BoxDecoration(
                                color: ColorSet.superLightGrey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                            const Center(
                              child: Text(
                                '독후감이 저장되었어요 👏',
                                style: TextStyles.phraseModalMentStyle,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: 60,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: ColorSet.superLightGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              const CupertinoActivityIndicator(
                                radius: 17,
                                animating: true,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '독후감 저장 중...',
                                style: TextStyles.phraseModalMentStyle.copyWith(
                                  color: ColorSet.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 60,
                      height: 8,
                      decoration: BoxDecoration(
                        color: ColorSet.superLightGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '독후감 작성',
                      style: TextStyles.timerBottomSheetTitleStyle,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      '책을 읽은 뒤 감상을 자유롭게 적어보세요',
                      style: TextStyles.timerBottomSheetDescriptionStyle,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '독후감은 외부로 공개되지 않아요',
                      style:
                          TextStyles.timerBottomSheetDescriptionStyle.copyWith(
                        color: ColorSet.semiDarkGrey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: Scaler.width(0.8, context),
                      child: TextField(
                        controller: widget.textarea,
                        onChanged: (value) {
                          setState(() {
                            bookReport = value;
                          });
                        },
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        decoration: const InputDecoration(
                          hintText: "독후감을 입력하세요",
                          hintStyle: TextStyles.timerBottomSheetHintTextStyle,
                          contentPadding: EdgeInsets.all(15),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: ColorSet.lightGrey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: ColorSet.lightGrey,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      onPressed: () async {
                        AmplitudeService().logEvent(
                          AmplitudeEvent.recordSaveReportButton,
                          context.read<UserInfoState>().userInfo.userUuid,
                        );
                        await submitBookReport();
                      },
                      width: Scaler.width(0.8, context),
                      height: 45,
                      child: const Text(
                        '저장하기',
                        style: TextStyles.loginButtonStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
