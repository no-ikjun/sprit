import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:share_plus/share_plus.dart';
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
  final int limit;
  final String questUuid;
  final String questTitle;
  const QuestBottomInfo({
    super.key,
    required this.startDate,
    required this.applyCount,
    required this.limit,
    required this.questUuid,
    required this.questTitle,
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
    final double progress = widget.limit > 0
        ? (widget.applyCount / widget.limit).clamp(0.0, 1.0)
        : 0.0;
    final bool isAlmostFull = progress >= 0.8;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          SizedBox(
            width: Scaler.width(0.85, context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 마감까지 섹션
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/clock_icon.svg',
                        width: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '마감까지',
                              style: TextStyles.questDetailBottomMenuStyle,
                            ),
                            Text(
                              widget.startDate == ''
                                  ? ''
                                  : getRemainingTime(
                                      DateTime.parse(widget.startDate)),
                              style: TextStyles.questDetailBottomDatatyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: ColorSet.lightGrey,
                ),
                // 공유 버튼
                Builder(
                  builder: (context) {
                    return InkWell(
                      onTap: () {
                        final box = context.findRenderObject() as RenderBox?;
                        final String storeUrl = Platform.isIOS
                            ? 'https://apps.apple.com/us/app/%EC%8A%A4%ED%94%84%EB%A6%BF-%EA%BE%B8%EC%A4%80%ED%95%9C-%EB%8F%85%EC%84%9C%EC%8A%B5%EA%B4%80-%EB%A7%8C%EB%93%A4%EA%B8%B0/id6475924225'
                            : 'https://play.google.com/store/apps/details?id=com.ikjunchoi_android.sprit';
                        Share.share(
                          '📚 스프릿 퀘스트에 함께 참여해요!\n\n"${widget.questTitle}"\n\n👉 앱 다운로드\n$storeUrl',
                          subject: '스프릿 퀘스트 공유',
                          sharePositionOrigin:
                              box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorSet.superLightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.ios_share_rounded,
                          size: 22,
                          color: ColorSet.darkGrey,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // 참여 현황 프로그레스 바
          SizedBox(
            width: Scaler.width(0.85, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/people_icon.svg',
                          width: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '참여 현황',
                          style: TextStyles.questDetailBottomMenuStyle,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.applyCount}',
                          style: TextStyles.questDetailBottomDatatyle.copyWith(
                            color: isAlmostFull
                                ? ColorSet.primary
                                : ColorSet.darkGrey,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' / ${widget.limit}명',
                          style: TextStyles.questDetailBottomMenuStyle,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // 배경 바
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorSet.superLightGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // 진행 바
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      height: 8,
                      width: Scaler.width(0.85, context) * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAlmostFull
                              ? [ColorSet.primary, const Color(0xFFFF6B6B)]
                              : [ColorSet.primary, ColorSet.primary],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
                if (isAlmostFull)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '마감 임박!',
                          style: TextStyles.questDetailBottomMenuStyle.copyWith(
                            color: const Color(0xFFFF6B6B),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            onPressed: () async {
              try {
                QuestApplyInfo applyInfo =
                    await QuestService.findQuestApply(widget.questUuid);
                if (applyInfo.applyUuid == '') {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.questApplyButton,
                    properties: {
                      'userUuid':
                          context.read<UserInfoState>().userInfo.userUuid,
                    },
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
              } catch (e) {
                // 에러 처리
              }
            },
            width: Scaler.width(0.85, context),
            height: 50,
            child: const Text(
              '참여 신청하기',
              style: TextStyles.loginButtonStyle,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
