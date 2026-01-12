import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/screens/quest/widgets/quest_bottom_info.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class QuestDetailScreen extends StatefulWidget {
  final String questUuid;
  const QuestDetailScreen({super.key, required this.questUuid});

  @override
  State<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends State<QuestDetailScreen> {
  QuestInfo questInfo = const QuestInfo(
    questUuid: '',
    title: '',
    shortDescription: '',
    longDescription: '',
    mission: '',
    iconUrl: '',
    thumbnailUrl: '',
    startDate: '',
    endDate: '',
    limit: 0,
    applyCount: 0,
    isEnded: false,
    createdAt: '',
  );
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    QuestService.findQuestByUuid(widget.questUuid).then((value) {
      setState(() {
        questInfo = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorSet.primary.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: QuestBottomInfo(
          applyCount: questInfo.applyCount,
          startDate: questInfo.startDate,
          questUuid: questInfo.questUuid,
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: '퀘스트',
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        radius: 17,
                        animating: true,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  questInfo.iconUrl,
                                  width: 70,
                                  height: 70,
                                ),
                                SizedBox(
                                  width: Scaler.width(0.85, context) - 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        questInfo.title,
                                        style: TextStyles.questDetailTitleStyle,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        questInfo.shortDescription,
                                        style: TextStyles
                                            .questDetailShortDescStyle,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: Scaler.width(1, context),
                            color: ColorSet.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: Scaler.width(0.85, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '퀘스트 상세 정보',
                                      style: TextStyles.questDetailMenuStyle,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      questInfo.longDescription,
                                      style:
                                          TextStyles.questDetailLongDescStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: Scaler.width(1, context),
                            color: ColorSet.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: Scaler.width(0.85, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '퀘스트 일정',
                                      style: TextStyles.questDetailMenuStyle,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '퀘스트 시작',
                                          style: TextStyles
                                              .questDetailScheduleStyle
                                              .copyWith(
                                            color: ColorSet.semiDarkGrey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          getFormattedDateTime(
                                              questInfo.startDate),
                                          style: TextStyles
                                              .questDetailScheduleStyle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '퀘스트 종료',
                                          style: TextStyles
                                              .questDetailScheduleStyle
                                              .copyWith(
                                            color: ColorSet.semiDarkGrey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          getFormattedDateTime(
                                              questInfo.endDate),
                                          style: TextStyles
                                              .questDetailScheduleStyle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '진행 기간',
                                          style: TextStyles
                                              .questDetailScheduleStyle
                                              .copyWith(
                                            color: ColorSet.semiDarkGrey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '${DateTime.parse(questInfo.endDate).difference(DateTime.parse(questInfo.startDate)).inDays + 1}일',
                                          style: TextStyles
                                              .questDetailScheduleStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: Scaler.width(1, context),
                            color: ColorSet.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: Scaler.width(0.85, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '퀘스트 미션',
                                      style: TextStyles.questDetailMenuStyle,
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      questInfo.mission.replaceAll('\\n', '\n'),
                                      style: TextStyles.questDetailMissionStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
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
