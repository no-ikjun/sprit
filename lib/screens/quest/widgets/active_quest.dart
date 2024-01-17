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
                  child: Text(
                    '퀘스트 모집 준비 중 🔥',
                    style: TextStyles.questButtonStyle,
                  ),
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
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorSet.primary.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 0),
                                ),
                              ]),
                          child: Column(
                            children: [
                              Image.network(
                                activeQuests[index].thumbnailUrl,
                                width: 180,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 180,
                                    height: 90,
                                    color: ColorSet.lightGrey,
                                    child: const Center(
                                      child: Text(
                                        '이미지를 불러올 수 없습니다.',
                                        style: TextStyles.questWidgetTitleStyle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          activeQuests[index].title.length > 12
                                              ? SizedBox(
                                                  width: 156,
                                                  height: 20,
                                                  child: Marquee(
                                                    text: activeQuests[index]
                                                        .title,
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
                                                    fadingEdgeStartFraction:
                                                        0.1,
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
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '마감까지',
                                            style: TextStyles
                                                .questWidgetDescriptionStyle
                                                .copyWith(
                                              color: ColorSet.semiDarkGrey,
                                            ),
                                          ),
                                          const Text(
                                            '7일 14시간 4분',
                                            style: TextStyles
                                                .questWidgetDescriptionStyle,
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
