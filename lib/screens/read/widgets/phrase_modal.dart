import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/switch_button.dart';

Future<String> setPhrase(
  BuildContext context,
  String bookUuid,
  String phrase,
  bool remind,
) async {
  return await PhraseService.setNewPhrase(context, bookUuid, phrase, remind);
}

class PhraseModal extends StatefulWidget {
  const PhraseModal({
    super.key,
    required this.textarea,
    required this.bookUuid,
  });

  final TextEditingController textarea;
  final String bookUuid;

  @override
  State<PhraseModal> createState() => _PhraseModalState();
}

class _PhraseModalState extends State<PhraseModal> {
  String phrase = '';
  bool remind = true;

  bool isLoading = false;
  bool isSubmitted = false;

  Future<void> submitPhrase() async {
    setState(() {
      isSubmitted = true;
      isLoading = true;
    });
    setPhrase(context, widget.bookUuid, phrase, remind).then((value) {
      if (value != '') {
        setState(() {
          isLoading = false;
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
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
                                '문구가 저장되었어요 👏',
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
                                '문구 기록 중...',
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
                      '문구 작성',
                      style: TextStyles.timerBottomSheetTitleStyle,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      '기억하고 싶은 문구를 작성해주세요',
                      style: TextStyles.timerBottomSheetDescriptionStyle,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: Scaler.width(0.8, context),
                      child: TextField(
                        controller: widget.textarea,
                        onChanged: (value) {
                          if (value.length > 40) {
                            setState(() {
                              remind = false;
                            });
                          }
                          setState(() {
                            phrase = value;
                          });
                        },
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: "예) 선택. 집중. 몰입 대상을 정하자.",
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
                    SizedBox(
                      width: Scaler.width(0.8, context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('리마인드 알림 받기',
                                  style: TextStyles
                                      .timerBottomSheetReminderTextStyle),
                              Text(
                                '40자 이내의 문구만 알림으로 받을 수 있어요',
                                style: TextStyles
                                    .timerBottomSheetReminderMentStyle,
                              ),
                            ],
                          ),
                          CustomSwitch(
                            onToggle: () {
                              if (phrase.length <= 40) {
                                setState(() {
                                  remind = !remind;
                                });
                              }
                            },
                            switchValue: remind,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      onPressed: () async {
                        await submitPhrase();
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
