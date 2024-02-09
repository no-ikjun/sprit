import 'package:flutter/material.dart';
import 'package:sprit/apis/services/quest.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/screens/quest/widgets/ongoing_badge.dart';

class SmallQuestWidget extends StatelessWidget {
  final QuestInfo questInfo;
  final QuestApplyInfo questApplyInfo;
  final bool isLargeMargin;
  const SmallQuestWidget({
    super.key,
    required this.questInfo,
    required this.questApplyInfo,
    required this.isLargeMargin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteName.questDetail,
          arguments: questInfo.questUuid,
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: isLargeMargin
            ? const EdgeInsets.only(bottom: 7)
            : const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Image.network(
              questInfo.iconUrl,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OngoingBadge(state: questApplyInfo.state),
                    Flexible(
                      child: Text(
                        questInfo.title,
                        style: TextStyles.questWidgetTitleStyle
                            .copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${getQuestStatusMent(questApplyInfo)}  ',
                          style: TextStyles.questWidgetDescriptionStyle
                              .copyWith(color: ColorSet.semiDarkGrey),
                        ),
                        Text(
                          getQuestStatusData(questInfo, questApplyInfo),
                          style: TextStyles.questWidgetDescriptionStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
