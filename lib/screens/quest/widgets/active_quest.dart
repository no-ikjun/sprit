import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class ActiveQuestsWidget extends StatelessWidget {
  const ActiveQuestsWidget({
    super.key,
    required this.activeQuests,
    required this.isLoading,
  });

  final List<QuestInfo> activeQuests;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return activeQuests.isEmpty
        ? Column(
            children: [
              const SizedBox(
                height: 11,
              ),
              Container(
                width: Scaler.width(0.85, context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000).withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 18,
                ),
                child: const Center(
                  child: Text('퀘스트 모집 준비 중 🔥',
                      style: TextStyles.questButtonStyle),
                ),
              ),
              const SizedBox(
                height: 11,
              ),
            ],
          )
        : Container(
            height: 202,
            alignment: Alignment.center,
            width: Scaler.width(1, context),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: activeQuests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        (index == 0)
                            ? SizedBox(width: Scaler.width(0.075, context))
                            : Container(),
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF000000).withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 18,
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '모집 중🔥',
                                    style: TextStyles.questWidgetLabelStyle,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          activeQuests[index].iconUrl,
                                          width: 40,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text(
                                              '모집 마감 D-4',
                                              style: TextStyles
                                                  .questWidgetTitleStyle,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  '6명',
                                                  style: TextStyles
                                                      .questWidgetDescriptionStyle,
                                                ),
                                                Text(
                                                  ' 더 참여 가능',
                                                  style: TextStyles
                                                      .questWidgetDescriptionStyle
                                                      .copyWith(
                                                    color:
                                                        ColorSet.semiDarkGrey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        activeQuests[index].title.length > 12
                                            ? SizedBox(
                                                width: 140,
                                                height: 20,
                                                child: Marquee(
                                                  text:
                                                      activeQuests[index].title,
                                                  style: TextStyles
                                                      .questWidgetTitleStyle,
                                                  velocity: 30.0,
                                                  blankSpace: 120,
                                                  pauseAfterRound:
                                                      const Duration(
                                                    seconds: 10,
                                                  ),
                                                  showFadingOnlyWhenScrolling:
                                                      true,
                                                  fadingEdgeStartFraction: 0.1,
                                                  fadingEdgeEndFraction: 0.1,
                                                  accelerationDuration:
                                                      const Duration(
                                                    seconds: 1,
                                                  ),
                                                  accelerationCurve:
                                                      Curves.linear,
                                                  decelerationDuration:
                                                      const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  decelerationCurve:
                                                      Curves.easeOut,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    activeQuests[index].title,
                                                    style: TextStyles
                                                        .questWidgetTitleStyle,
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '퀘스트 진행 기간  ',
                                              style: TextStyles
                                                  .questWidgetDescriptionStyle
                                                  .copyWith(
                                                color: ColorSet.semiDarkGrey,
                                              ),
                                            ),
                                            const Text(
                                              '7일',
                                              style: TextStyles
                                                  .questWidgetDescriptionStyle,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '실시간 참여 인원  ',
                                              style: TextStyles
                                                  .questWidgetDescriptionStyle
                                                  .copyWith(
                                                color: ColorSet.semiDarkGrey,
                                              ),
                                            ),
                                            const Text(
                                              '14명',
                                              style: TextStyles
                                                  .questWidgetDescriptionStyle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '자세히 보기 >',
                                          style: TextStyles.questButtonStyle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        (index != activeQuests.length - 1)
                            ? const SizedBox(
                                width: 11,
                              )
                            : Container(),
                        (index == activeQuests.length - 1)
                            ? SizedBox(width: Scaler.width(0.075, context))
                            : Container(),
                      ],
                    );
                  }),
            ),
          );
  }
}
