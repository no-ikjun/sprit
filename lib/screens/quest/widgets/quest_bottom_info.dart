import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/popups/quest/after_end.dart';
import 'package:sprit/popups/quest/already_applied.dart';
import 'package:sprit/popups/quest/apply_phone.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class QuestBottomInfo extends StatefulWidget {
  final String startDate;
  final int applyCount;
  final String questUuid;
  const QuestBottomInfo({
    super.key,
    required this.startDate,
    required this.applyCount,
    required this.questUuid,
  });

  @override
  State<QuestBottomInfo> createState() => _QuestBottomInfoState();
}

class _QuestBottomInfoState extends State<QuestBottomInfo> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: Scaler.width(0.85, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        width: Scaler.width(0.425, context) - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/clock_icon.svg',
                              width: Scaler.width(0.08, context),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '마감까지',
                                  style: TextStyles.questDetailBottomMenuStyle,
                                ),
                                SizedBox(
                                  width: Scaler.width(0.85, context) * 0.5 -
                                      Scaler.width(0.08, context) -
                                      30,
                                  child: Text(
                                    widget.startDate == ''
                                        ? ''
                                        : getRemainingTime(
                                            DateTime.parse(widget.startDate)),
                                    style: TextStyles.questDetailBottomDatatyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: ColorSet.lightGrey,
                    ),
                    InkWell(
                      onTap: () async {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        width: Scaler.width(0.425, context) - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/people_icon.svg',
                              width: Scaler.width(0.08, context),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '실시간 참여자',
                                  style: TextStyles.questDetailBottomMenuStyle,
                                ),
                                Text(
                                  '${widget.applyCount}명',
                                  style: TextStyles.questDetailBottomDatatyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            onPressed: () async {
              QuestApplyInfo applyInfo =
                  await QuestService.findQuestApply(context, widget.questUuid);
              if (applyInfo.applyUuid == '') {
                AmplitudeService().logEvent(
                  AmplitudeEvent.questApplyButton,
                  context.read<UserInfoState>().userInfo.userUuid,
                );
                showModal(
                  context,
                  QuestApplyPhone(questUuid: widget.questUuid),
                  false,
                );
              } else if (getRemainingTime(DateTime.parse(widget.startDate)) ==
                  '0시간 0분 0초') {
                showModal(
                  context,
                  const AfterEndQuest(),
                  false,
                );
              } else {
                showModal(
                  context,
                  const AlreadyAppliedQuest(),
                  false,
                );
              }
            },
            width: Scaler.width(0.85, context),
            height: 50,
            child: const Text(
              '참여 신청하기',
              style: TextStyles.loginButtonStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
