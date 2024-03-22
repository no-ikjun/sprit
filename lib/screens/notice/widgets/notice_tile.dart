import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/notice.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';

class NoticeTile extends StatelessWidget {
  final NoticeInfo noticeInfo;

  const NoticeTile({
    super.key,
    required this.noticeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                            noticeInfo.type == 'UPDATE'
                                ? 'assets/images/notice_update_icon.svg'
                                : noticeInfo.type == 'BUG'
                                    ? 'assets/images/notice_bug_icon.svg'
                                    : 'assets/images/notice_event_icon.svg',
                            width: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            noticeInfo.type == 'UPDATE'
                                ? '업데이트'
                                : noticeInfo.type == 'BUG'
                                    ? '버그 리포트'
                                    : '이벤트',
                            style: TextStyles.noticeTileTypeStyle,
                          ),
                        ],
                      ),
                      Text(
                        getPastTime(noticeInfo.createdAt),
                        style: TextStyles.noticeTileTypeStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(
                      noticeInfo.title,
                      style: TextStyles.noticeTileTitleStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
