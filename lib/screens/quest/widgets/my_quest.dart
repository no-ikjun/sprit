import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/quest/widgets/ongoing_badge.dart';

class MyQuestsWidget extends StatelessWidget {
  const MyQuestsWidget({
    super.key,
    required this.myQuests,
    required this.isLoading,
  });

  final List<AppliedQuestResponse> myQuests;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        vertical: 10,
        horizontal: 18,
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '나의 퀘스트 현황 📝',
                style: TextStyles.questWidgetLabelStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CupertinoActivityIndicator(
                    radius: 15,
                    animating: true,
                  ),
                )
              : myQuests.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        '❌ 진행 중인 퀘스트가 없습니다 ❌',
                        style: TextStyles.questButtonStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: myQuests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: (index == myQuests.length - 1)
                              ? const EdgeInsets.only(bottom: 7)
                              : const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Image.network(
                                myQuests[index].questInfo.iconUrl,
                                width: 55,
                                height: 55,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OngoingBadge(
                                          state: myQuests[index]
                                              .questApplyInfo
                                              .state),
                                      Flexible(
                                        child: Text(
                                          myQuests[index].questInfo.title,
                                          style: TextStyles
                                              .questWidgetTitleStyle
                                              .copyWith(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '마감까지  ',
                                            style: TextStyles
                                                .questWidgetDescriptionStyle
                                                .copyWith(
                                                    color:
                                                        ColorSet.semiDarkGrey),
                                          ),
                                          const Text(
                                            'D-4',
                                            style: TextStyles
                                                .questWidgetDescriptionStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            width: Scaler.width(0.72, context),
            color: ColorSet.lightGrey,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 6),
            child: Text(
              '🎉 완료한 퀘스트 모두 보기',
              style: TextStyles.questButtonStyle,
            ),
          )
        ],
      ),
    );
  }
}
