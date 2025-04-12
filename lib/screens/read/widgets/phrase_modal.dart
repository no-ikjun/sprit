import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/phrase.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/switch_button.dart';

Future<String> setPhrase(
  BuildContext context,
  String bookUuid,
  String phrase,
  int page,
  bool remind,
  bool share,
) async {
  return await PhraseService.setNewPhrase(
    context,
    bookUuid,
    phrase,
    page,
    remind,
    share,
  );
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
  bool share = true;

  bool isLoading = false;
  bool isSubmitted = false;

  bool nextStep = false;

  String pageText = '';

  late TextEditingController pageController;

  Future<void> submitPhrase() async {
    int pageInt = int.tryParse(pageText) ?? 0;
    setState(() {
      isSubmitted = true;
      isLoading = true;
    });
    setPhrase(
      context,
      widget.bookUuid,
      phrase,
      pageInt,
      remind,
      share,
    ).then((value) {
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
  void initState() {
    super.initState();
    pageController = TextEditingController(text: pageText);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
                      '문구 (스크랩) 작성',
                      style: TextStyles.timerBottomSheetTitleStyle,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      nextStep ? '몇 페이지에 나온 내용인가요?' : '기억하고 싶은 문구를 작성해주세요',
                      style: TextStyles.timerBottomSheetDescriptionStyle,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    nextStep
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 130,
                                height: 40,
                                child: TextField(
                                  controller: pageController,
                                  autofocus: true,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'),
                                    ),
                                  ],
                                  style: TextStyles.textFieldStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                  onChanged: (value) => setState(() {
                                    pageText = value;
                                  }),
                                  decoration: InputDecoration(
                                    hintText: '페이지 번호',
                                    hintStyle:
                                        TextStyles.textFieldStyle.copyWith(
                                      color: ColorSet.grey,
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorSet.primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.all(5),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ColorSet.border,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '쪽',
                                style: TextStyles
                                    .timerBottomSheetDescriptionStyle
                                    .copyWith(
                                  color: ColorSet.semiDarkGrey,
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            width: Scaler.width(0.8, context),
                            child: TextField(
                              controller: widget.textarea,
                              onChanged: (value) {
                                if (value.length > 50) {
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
                                hintStyle:
                                    TextStyles.timerBottomSheetHintTextStyle,
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
                    nextStep
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 27,
                              ),
                              SizedBox(
                                width: Scaler.width(0.8, context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomButton(
                                      onPressed: () async {
                                        setState(() {
                                          pageText = '';
                                        });
                                        await submitPhrase();
                                      },
                                      width: Scaler.width(0.39, context),
                                      height: 45,
                                      borderColor: ColorSet.lightGrey,
                                      color: ColorSet.lightGrey,
                                      child: const Text(
                                        '건너뛰기',
                                        style: TextStyles.loginButtonStyle,
                                      ),
                                    ),
                                    CustomButton(
                                      onPressed: () async {
                                        await submitPhrase();
                                      },
                                      width: Scaler.width(0.39, context),
                                      height: 45,
                                      borderColor: ColorSet.primary,
                                      color: ColorSet.primary,
                                      child: const Text(
                                        '저장하기',
                                        style: TextStyles.loginButtonStyle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: Scaler.width(0.8, context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('문구 공유하기',
                                            style: TextStyles
                                                .timerBottomSheetReminderTextStyle),
                                        Text(
                                          '공유한 문구는 프로필 페이지에 표시돼요',
                                          style: TextStyles
                                              .timerBottomSheetReminderMentStyle,
                                        ),
                                      ],
                                    ),
                                    CustomSwitch(
                                      onToggle: () {
                                        setState(() {
                                          share = !share;
                                        });
                                      },
                                      switchValue: share,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: Scaler.width(0.8, context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('리마인드 알림 받기',
                                            style: TextStyles
                                                .timerBottomSheetReminderTextStyle),
                                        Text(
                                          '100자 이내의 문구만 알림으로 받을 수 있어요',
                                          style: TextStyles
                                              .timerBottomSheetReminderMentStyle,
                                        ),
                                      ],
                                    ),
                                    CustomSwitch(
                                      onToggle: () {
                                        if (phrase.length <= 100) {
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
                                  AmplitudeService().logEvent(
                                    AmplitudeEvent.recordSavePhrase,
                                    properties: {
                                      'userUuid': context
                                          .read<UserInfoState>()
                                          .userInfo
                                          .userUuid,
                                    },
                                  );
                                  setState(() {
                                    nextStep = true;
                                  });
                                },
                                width: Scaler.width(0.8, context),
                                height: 45,
                                child: const Text(
                                  '다음으로',
                                  style: TextStyles.loginButtonStyle,
                                ),
                              ),
                            ],
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
