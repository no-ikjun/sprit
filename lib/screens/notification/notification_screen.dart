import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/notification/widgets/control_menu.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isReadingTimeNotificationOn = true;
  bool isReminderNotificationOn = true;
  bool isNewQuestNotificationOn = true;
  bool isQuestEndNotificationOn = true;
  bool isQuestTimeNotificationOn = true;
  bool isMarketingNotificationOn = true;
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
              label: '알림 설정',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Text(
                            '독서 알림',
                            style: TextStyles.notificationLabelStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: Scaler.width(1, context),
                          color: ColorSet.white,
                          child: Column(
                            children: [
                              NotificationControlMenu(
                                title: '독서 시간 알림',
                                description: '매일 독서할 수 있도록 같은 시간에 알림을 받아요',
                                switchValue: isReadingTimeNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isReadingTimeNotificationOn =
                                        !isReadingTimeNotificationOn;
                                  });
                                },
                              ),
                              isReadingTimeNotificationOn
                                  ? const Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: ColorSet.background,
                                    )
                                  : Container(),
                              isReadingTimeNotificationOn
                                  ? NotificationControlMenu(
                                      title: '시간 설정',
                                      description: '매일 알림받을 시간을 설정하세요',
                                      onClick: () {
                                        HapticFeedback.lightImpact();
                                      },
                                      isSwitch: false,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Text(
                            '리마인드 알림',
                            style: TextStyles.notificationLabelStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: Scaler.width(1, context),
                          color: ColorSet.white,
                          child: Column(
                            children: [
                              NotificationControlMenu(
                                title: '문구 리마인드',
                                description: '기억에 남길 문구를 알림으로 받을 수 있어요',
                                switchValue: isReminderNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isReminderNotificationOn =
                                        !isReminderNotificationOn;
                                  });
                                },
                              ),
                              isReminderNotificationOn
                                  ? const Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: ColorSet.background,
                                    )
                                  : Container(),
                              isReminderNotificationOn
                                  ? NotificationControlMenu(
                                      title: '문구 선택 · 시간 설정',
                                      description: '기억에 남길 문구를 선택하고 시간을 설정하세요',
                                      onClick: () {
                                        HapticFeedback.lightImpact();
                                      },
                                      isSwitch: false,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Text(
                            '퀘스트 알림',
                            style: TextStyles.notificationLabelStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: Scaler.width(1, context),
                          color: ColorSet.white,
                          child: Column(
                            children: [
                              NotificationControlMenu(
                                title: '새로운 퀘스트 정보',
                                description: '새로운 퀘스트가 열리면 알림으로 안내해드려요',
                                switchValue: isNewQuestNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isNewQuestNotificationOn =
                                        !isNewQuestNotificationOn;
                                  });
                                },
                              ),
                              const Divider(
                                height: 2,
                                thickness: 2,
                                color: ColorSet.background,
                              ),
                              NotificationControlMenu(
                                title: '퀘스트 마감 알림',
                                description: '참여한 퀘스트의 마감일이 다가올 때 알려드려요',
                                switchValue: isQuestEndNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isQuestEndNotificationOn =
                                        !isQuestEndNotificationOn;
                                  });
                                },
                              ),
                              const Divider(
                                height: 2,
                                thickness: 2,
                                color: ColorSet.background,
                              ),
                              NotificationControlMenu(
                                title: '퀘스트 진행 상황 알림',
                                description: '퀘스트가 진행되는 동안 무엇을 해야할지 알려드려요',
                                switchValue: isQuestTimeNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isQuestTimeNotificationOn =
                                        !isQuestTimeNotificationOn;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Scaler.width(0.85, context),
                          child: const Text(
                            '이벤트 · 마케팅 알림 ',
                            style: TextStyles.notificationLabelStyle,
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          width: Scaler.width(1, context),
                          color: ColorSet.white,
                          child: Column(
                            children: [
                              NotificationControlMenu(
                                title: '마케팅 정보 수신',
                                description: '광고성 정보 수신 동의 여부',
                                switchValue: isMarketingNotificationOn,
                                onClick: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    isMarketingNotificationOn =
                                        !isMarketingNotificationOn;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
