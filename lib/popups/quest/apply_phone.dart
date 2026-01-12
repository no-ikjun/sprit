import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class QuestApplyPhone extends StatefulWidget {
  final String questUuid;
  const QuestApplyPhone({super.key, required this.questUuid});

  @override
  State<QuestApplyPhone> createState() => _QuestApplyPhoneState();
}

class _QuestApplyPhoneState extends State<QuestApplyPhone> {
  String phoneNumber = '';
  bool isAllowed = false;
  bool isSubmitted = false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        phoneNumber = _controller.text;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isSubmitted
        ? Container(
            width: Scaler.width(0.85, context),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: const Text(
              '퀘스트 신청이 완료되었어요',
              style: TextStyles.notificationConfirmModalDescriptionStyle,
              textAlign: TextAlign.center,
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                '퀘스트 신청',
                style: TextStyles.notificationConfirmModalTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                '리워드 지급을 위해\n전화번호를 입력해주세요',
                style: TextStyles.notificationConfirmModalDescriptionStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.8, context),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value.toString();
                    });
                  },
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: "010-0000-0000",
                    hintStyle: TextStyles.timerBottomSheetHintTextStyle,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: ColorSet.lightGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: ColorSet.lightGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.questAgreePhoneNumber,
                    properties: {
                      'userUuid':
                          context.read<UserInfoState>().userInfo.userUuid,
                    },
                  );
                  setState(() {
                    isAllowed = !isAllowed;
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      isAllowed
                          ? 'assets/images/check_blue.svg'
                          : 'assets/images/check_grey.svg',
                      width: 16,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '개인정보 수집 및 이용 동의',
                      style: TextStyles.signUpLabel.copyWith(
                        decoration: TextDecoration.none,
                        color: isAllowed
                            ? ColorSet.primary
                            : ColorSet.semiDarkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '전화번호는 퀘스트 리워드 지급을 위해서만 사용되며\n퀘스트 종료 즉시 삭제됩니다.',
                style: TextStyles.myLibraryWarningStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: Scaler.width(0.85, context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      width: Scaler.width(0.8, context) * 0.5 - 5,
                      height: 50,
                      color: ColorSet.lightGrey,
                      borderColor: ColorSet.lightGrey,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '취소',
                        style: TextStyles.buttonLabelStyle,
                      ),
                    ),
                    CustomButton(
                      width: Scaler.width(0.8, context) * 0.5 - 5,
                      height: 50,
                      onPressed: () async {
                        if (isAllowed) {
                          AmplitudeService().logEvent(
                            AmplitudeEvent.questInputPhoneNumber,
                            properties: {
                              'userUuid': context
                                  .read<UserInfoState>()
                                  .userInfo
                                  .userUuid,
                            },
                          );
                          await QuestService.applyQuest(
                            widget.questUuid,
                            phoneNumber,
                          ).then((value) async {
                            setState(() {
                              isSubmitted = true;
                            });
                            await Future.delayed(
                                const Duration(milliseconds: 400), () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RouteName.home,
                                (route) => false,
                              );
                            });
                          });
                        }
                      },
                      child: const Text(
                        '신청하기',
                        style: TextStyles.buttonLabelStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
