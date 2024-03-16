import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/notification.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/notification/notification_confirm.dart';
import 'package:sprit/screens/notification/widgets/control_menu.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

Future<TimeAgreeInfo> getTimeAgreeInfo(
  BuildContext context,
) async {
  return await NotificationService.getTimeAgreeInfo(context);
}

Future<RemindAgreeInfo> getRemindAgreeInfo(
  BuildContext context,
) async {
  return await NotificationService.getRemindAgreeInfo(context);
}

Future<QuestAgreeInfo> getQuestAgreeInfo(
  BuildContext context,
) async {
  return await NotificationService.getQuestAgreeInfo(context);
}

Future<bool> getMarketingAgreeInfo(
  BuildContext context,
) async {
  return await NotificationService.getMarketingAgree(context);
}

Future<bool> updateMarketingAgreeInfo(
  BuildContext context,
  bool marketingAgree,
) async {
  return await NotificationService.updateMarketingAgree(
    context,
    marketingAgree,
  );
}

Future<bool> updateTimeAgreeInfo(
    BuildContext context, bool agree01, int time01, bool agree02) async {
  return await NotificationService.updateTimeAgree(
    context,
    agree01,
    time01,
    agree02,
  );
}

Future<bool> updateRemindAgreeInfo(
  BuildContext context,
  bool agree01,
  int time01,
) async {
  return await NotificationService.updateRemindAgree(
    context,
    agree01,
    time01,
  );
}

Future<bool> updateQuestAgreeInfo(
  BuildContext context,
  bool agree01,
  bool agree02,
  bool agree03,
) async {
  return await NotificationService.updateQuestAgree(
    context,
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

  bool isWeeklyReportNotificationOn = false;
  bool isReadingTimeNotificationOn = false;
  int readingTime = 0;
  bool isReminderNotificationOn = false;
  int reminderTime = 0;
  bool isNewQuestNotificationOn = false;
  bool isQuestEndNotificationOn = false;
  bool isQuestTimeNotificationOn = false;
  bool isMarketingNotificationOn = false;

  Future<void> _fetchData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final result = await Future.wait([
      getTimeAgreeInfo(context),
      getRemindAgreeInfo(context),
      getQuestAgreeInfo(context),
      getMarketingAgreeInfo(context),
    ]);
    setState(() {
      TimeAgreeInfo timeAgreeInfo = result[0] as TimeAgreeInfo;
      isWeeklyReportNotificationOn = timeAgreeInfo.agree02;
      isReadingTimeNotificationOn = timeAgreeInfo.agree01;
      readingTime = timeAgreeInfo.time01;
      RemindAgreeInfo remindAgreeInfo = result[1] as RemindAgreeInfo;
      isReminderNotificationOn = remindAgreeInfo.agree01;
      reminderTime = remindAgreeInfo.time01;
      QuestAgreeInfo questAgreeInfo = result[2] as QuestAgreeInfo;
      isNewQuestNotificationOn = questAgreeInfo.agree01;
      isQuestEndNotificationOn = questAgreeInfo.agree02;
      isQuestTimeNotificationOn = questAgreeInfo.agree03;
      isMarketingNotificationOn = result[3] as bool;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData(context);
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
                                      title: '독서 리포트 알림',
                                      description: '매주 독서 리포트를 알림으로 받아요',
                                      switchValue: isWeeklyReportNotificationOn,
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          isWeeklyReportNotificationOn =
                                              !isWeeklyReportNotificationOn;
                                        });
                                        final result =
                                            await updateTimeAgreeInfo(
                                          context,
                                          isReadingTimeNotificationOn,
                                          readingTime,
                                          isWeeklyReportNotificationOn,
                                        );

                                        if (result == false) {
                                          setState(() {
                                            isWeeklyReportNotificationOn =
                                                !isWeeklyReportNotificationOn;
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
                                      title: '독서 시간 알림',
                                      description:
                                          '매일 독서할 수 있도록 같은 시간에 알림을 받아요',
                                      switchValue: isReadingTimeNotificationOn,
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        setState(() {
                                          isReadingTimeNotificationOn =
                                              !isReadingTimeNotificationOn;
                                        });
                                        final result =
                                            await updateTimeAgreeInfo(
                                          context,
                                          isReadingTimeNotificationOn,
                                          readingTime,
                                          isWeeklyReportNotificationOn,
                                        );
                                        if (result == false) {
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
                                        setState(() {
                                          isReminderNotificationOn =
                                              !isReminderNotificationOn;
                                        });
                                        final result =
                                            await updateRemindAgreeInfo(
                                          context,
                                          isReminderNotificationOn,
                                          reminderTime,
                                        );
                                        if (result == false) {
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
                                        setState(() {
                                          isNewQuestNotificationOn =
                                              !isNewQuestNotificationOn;
                                        });
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          isNewQuestNotificationOn,
                                          isQuestEndNotificationOn,
                                          isQuestTimeNotificationOn,
                                        );
                                        if (result == false) {
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
                                        setState(() {
                                          isQuestEndNotificationOn =
                                              !isQuestEndNotificationOn;
                                        });
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          isNewQuestNotificationOn,
                                          isQuestEndNotificationOn,
                                          isQuestTimeNotificationOn,
                                        );
                                        if (result == false) {
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
                                        setState(() {
                                          isQuestTimeNotificationOn =
                                              !isQuestTimeNotificationOn;
                                        });
                                        final result =
                                            await updateQuestAgreeInfo(
                                          context,
                                          isNewQuestNotificationOn,
                                          isQuestEndNotificationOn,
                                          isQuestTimeNotificationOn,
                                        );
                                        if (result == false) {
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
                                      onClick: () async {
                                        HapticFeedback.lightImpact();
                                        final result =
                                            await updateMarketingAgreeInfo(
                                          context,
                                          !isMarketingNotificationOn,
                                        );
                                        if (result == true) {
                                          DateTime now = DateTime.now();
                                          String formattedDate = DateFormat(
                                                  'yyyy년 MM월 dd일\nHH시 mm분')
                                              .format(now);
                                          showModal(
                                              context,
                                              NotificationConfirm(
                                                title:
                                                    !isMarketingNotificationOn
                                                        ? "마케팅 정보 수신 동의"
                                                        : "마케팅 정보 수신 거부",
                                                description: !isMarketingNotificationOn
                                                    ? "아래 시간을 기준으로\n마케팅 정보 수신에 동의하였습니다"
                                                    : "아래 시간을 기준으로\n마케팅 정보 수신을 거부하였습니다",
                                                notificationInfo: formattedDate,
                                              ),
                                              false);
                                          setState(() {
                                            isMarketingNotificationOn =
                                                !isMarketingNotificationOn;
                                          });
                                        }
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
