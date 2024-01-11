import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                '모집 중인 퀘스트 🔥',
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
              : ListView.builder(
                  itemCount: activeQuests.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: (index == activeQuests.length - 1)
                          ? const EdgeInsets.only(bottom: 7)
                          : const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Image.network(
                            activeQuests[index].iconUrl,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: Text(
                                      activeQuests[index].title,
                                      style: TextStyles.questWidgetTitleStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '기간  ',
                                        style: TextStyles
                                            .questWidgetDescriptionStyle
                                            .copyWith(
                                                color: ColorSet.semiDarkGrey),
                                      ),
                                      Text(
                                        '${activeQuests[index].startDate.substring(0, 10)} ~ ${activeQuests[index].endDate.substring(0, 10)}',
                                        style: TextStyles
                                            .questWidgetDescriptionStyle,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '실시간 참여 인원  ',
                                        style: TextStyles
                                            .questWidgetDescriptionStyle
                                            .copyWith(
                                                color: ColorSet.semiDarkGrey),
                                      ),
                                      Text(
                                        '${activeQuests[index].applyCount.toString()}명',
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
        ],
      ),
    );
  }
}
