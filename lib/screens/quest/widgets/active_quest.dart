import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

class ActiveQuestsWidget extends StatefulWidget {
  const ActiveQuestsWidget({
    super.key,
    required this.activeQuests,
    required this.isLoading,
  });

  final List<QuestInfo> activeQuests;
  final bool isLoading;

  @override
  State<ActiveQuestsWidget> createState() => _ActiveQuestsWidgetState();
}

class _ActiveQuestsWidgetState extends State<ActiveQuestsWidget> {
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
    return widget.activeQuests.isEmpty
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
                    '새로운 퀘스트 준비 중 🔥',
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
            height: Scaler.width(0.3, context) * 0.5 + 40,
            alignment: Alignment.center,
            width: Scaler.width(1, context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.activeQuests.length,
              padding: EdgeInsets.symmetric(
                  horizontal: Scaler.width(0.075, context)),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    ScalableInkWell(
                      onTap: () {
                        AmplitudeService().logEvent(
                          AmplitudeEvent.questDetailClick,
                          properties: {
                            'userUuid':
                                context.read<UserInfoState>().userInfo.userUuid,
                            'questUuid': widget.activeQuests[index].questUuid,
                          },
                        );
                        Navigator.pushNamed(
                          context,
                          RouteName.questDetail,
                          arguments: widget.activeQuests[index].questUuid,
                        );
                      },
                      child: Container(
                        width: Scaler.width(0.7, context),
                        height: Scaler.width(0.3, context) * 0.5 + 20,
                        padding: const EdgeInsets.all(10),
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
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              child: Image.network(
                                widget.activeQuests[index].thumbnailUrl,
                                width: Scaler.width(0.3, context),
                                height: Scaler.width(0.3, context) * 0.5,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: Scaler.width(0.3, context),
                                    height: Scaler.width(0.3, context) * 0.5,
                                    color: ColorSet.lightGrey,
                                    child: const Center(
                                      child: Text(
                                        '이미지를 불러올 수 없습니다.',
                                        style: TextStyles
                                            .questWidgetDescriptionStyle,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      widget.activeQuests[index].title.length >
                                              12
                                          ? SizedBox(
                                              width: Scaler.width(0.4, context),
                                              height: 20,
                                              child: Marquee(
                                                text: widget
                                                    .activeQuests[index].title,
                                                style: TextStyles
                                                    .questWidgetTitleStyle,
                                                velocity: 30.0,
                                                blankSpace: 120,
                                                pauseAfterRound: const Duration(
                                                  seconds: 10,
                                                ),
                                                showFadingOnlyWhenScrolling:
                                                    true,
                                                fadingEdgeStartFraction: 0.1,
                                                fadingEdgeEndFraction: 0.1,
                                                accelerationDuration:
                                                    const Duration(seconds: 1),
                                                accelerationCurve:
                                                    Curves.linear,
                                                decelerationDuration:
                                                    const Duration(
                                                        milliseconds: 500),
                                                decelerationCurve:
                                                    Curves.easeOut,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.activeQuests[index]
                                                      .title,
                                                  style: TextStyles
                                                      .questWidgetTitleStyle,
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '신청마감까지',
                                        style: TextStyles
                                            .questWidgetDescriptionStyle
                                            .copyWith(
                                          color: ColorSet.semiDarkGrey,
                                        ),
                                      ),
                                      Text(
                                        getRemainingTime(DateTime.parse(widget
                                            .activeQuests[index].startDate)),
                                        style: TextStyles
                                            .questWidgetDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index != widget.activeQuests.length - 1)
                      const SizedBox(width: 11),
                  ],
                );
              },
            ),
          );
  }
}
