import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/quest/widgets/small_quest_widget.dart';

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
                        '진행 중인 퀘스트가 없어요',
                        style: TextStyles.questButtonStyle,
                      ),
                    )
                  : ListView.builder(
                      itemCount: myQuests.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return SmallQuestWidget(
                          questInfo: myQuests[index].questInfo,
                          questApplyInfo: myQuests[index].questApplyInfo,
                          isLargeMargin: index == myQuests.length - 1,
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
          InkWell(
            onTap: () {
              AmplitudeService().logEvent(
                AmplitudeEvent.questShowAll,
                properties: {
                  'userUuid': context.read<UserInfoState>().userInfo.userUuid,
                },
              );
              Navigator.pushNamed(context, RouteName.myQuest);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Padding(
              padding: EdgeInsets.only(top: 15, bottom: 6),
              child: Text(
                '나의 퀘스트 모두 보기',
                style: TextStyles.questButtonStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
