import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/screens/notification/widgets/control_menu.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<TimeAgreeInfo> getTimeAgreeInfo(
  BuildContext context,
  String fcmToken,
) async {
  return await NotificationService.getTimeAgreeInfo(context, fcmToken);
}

Future<RemindAgreeInfo> getRemindAgreeInfo(
  BuildContext context,
  String fcmToken,
) async {
  return await NotificationService.getRemindAgreeInfo(context, fcmToken);
}

Future<QuestAgreeInfo> getQuestAgreeInfo(
  BuildContext context,
  String fcmToken,
) async {
  return await NotificationService.getQuestAgreeInfo(context, fcmToken);
}

Future<bool> updateTimeAgreeInfo(
  BuildContext context,
  String fcmToken,
  bool agree01,
  int time01,
) async {
  return await NotificationService.updateTimeAgree(
    context,
    fcmToken,
    agree01,
    time01,
  );
}

Future<bool> updateRemindAgreeInfo(
  BuildContext context,
  String fcmToken,
  bool agree01,
  int time01,
) async {
  return await NotificationService.updateRemindAgree(
    context,
    fcmToken,
    agree01,
    time01,
  );
}

Future<bool> updateQuestAgreeInfo(
  BuildContext context,
  String fcmToken,
  bool agree01,
  bool agree02,
  bool agree03,
) async {
  return await NotificationService.updateQuestAgree(
    context,
    fcmToken,
    agree01,
    agree02,
    agree03,
  );
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  bool isReadingTimeNotificationOn = true;
  int readingTime = 0;
  bool isReminderNotificationOn = true;
  int reminderTime = 0;
  bool isNewQuestNotificationOn = true;
  bool isQuestEndNotificationOn = true;
  bool isQuestTimeNotificationOn = true;
  bool isMarketingNotificationOn = true;

  Future<void> _fetchData(BuildContext context, String fcmToken) async {
    setState(() {
      isLoading = true;
    });
    await getTimeAgreeInfo(context, fcmToken).then((value) {
      setState(() {
        isReadingTimeNotificationOn = value.agree01;
        readingTime = value.time01;
      });
      getRemindAgreeInfo(context, fcmToken).then((value) {
        setState(() {
          isReminderNotificationOn = value.agree01;
          reminderTime = value.time01;
        });
        getQuestAgreeInfo(context, fcmToken).then((value) {
          setState(() {
            isNewQuestNotificationOn = value.agree01;
            isQuestEndNotificationOn = value.agree02;
            isQuestTimeNotificationOn = value.agree03;
          });
        });
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final fcmToken = context.read<FcmTokenState>().fcmToken;
    _fetchData(context, fcmToken);
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
              label: '알림 설정',
            ),
            isLoading
                ? const Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CupertinoActivityIndicator(
                        radius: 18,
                        animating: true,
                      )
                    ],
                  )
                : Expanded(
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
                                      description:
                                          '매일 독서할 수 있도록 같은 시간에 알림을 받아요',
                                      switchValue: isReadingTimeNotificationOn,
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final fcmToken = context
                                            .read<FcmTokenState>()
                                            .fcmToken;
                                        final result =
                                            await updateTimeAgreeInfo(
                                          context,
                                          fcmToken,
                                          !isReadingTimeNotificationOn,
                                          readingTime,
                                        );
                                        if (result == true) {
                                          setState(() {
                                            isReadingTimeNotificationOn =
                                                !isReadingTimeNotificationOn;
                                          });
                                        }
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
                                              Navigator.pushNamed(
                                                context,
                                                RouteName.timeSetting,
                                              );
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
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final fcmToken = context
                                            .read<FcmTokenState>()
                                            .fcmToken;
                                        final result =
                                            await updateRemindAgreeInfo(
                                          context,
                                          fcmToken,
                                          !isReminderNotificationOn,
                                          reminderTime,
                                        );
                                        if (result == true) {
                                          setState(() {
                                            isReminderNotificationOn =
                                                !isReminderNotificationOn;
                                          });
                                        }
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
                                            description:
                                                '기억에 남길 문구를 선택하고 시간을 설정하세요',
                                            onClick: () {
                                              Navigator.pushNamed(
                                                context,
                                                RouteName.mentSetting,
                                              );
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
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final fcmToken = context
                                            .read<FcmTokenState>()
                                            .fcmToken;
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          fcmToken,
                                          !isNewQuestNotificationOn,
                                          isQuestEndNotificationOn,
                                          isQuestTimeNotificationOn,
                                        );
                                        if (result == true) {
                                          setState(() {
                                            isNewQuestNotificationOn =
                                                !isNewQuestNotificationOn;
                                          });
                                        }
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
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final fcmToken = context
                                            .read<FcmTokenState>()
                                            .fcmToken;
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          fcmToken,
                                          isNewQuestNotificationOn,
                                          !isQuestEndNotificationOn,
                                          isQuestTimeNotificationOn,
                                        );
                                        if (result == true) {
                                          setState(() {
                                            isQuestEndNotificationOn =
                                                !isQuestEndNotificationOn;
                                          });
                                        }
                                      },
                                    ),
                                    const Divider(
                                      height: 2,
                                      thickness: 2,
                                      color: ColorSet.background,
                                    ),
                                    NotificationControlMenu(
                                      title: '퀘스트 진행 상황 알림',
                                      description:
                                          '퀘스트가 진행되는 동안 무엇을 해야할지 알려드려요',
                                      switchValue: isQuestTimeNotificationOn,
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final fcmToken = context
                                            .read<FcmTokenState>()
                                            .fcmToken;
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          fcmToken,
                                          isNewQuestNotificationOn,
                                          isQuestEndNotificationOn,
                                          !isQuestTimeNotificationOn,
                                        );
                                        if (result == true) {
                                          setState(() {
                                            isQuestTimeNotificationOn =
                                                !isQuestTimeNotificationOn;
                                          });
                                        }
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
                              const SizedBox(
                                height: 25,
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
