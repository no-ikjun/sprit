import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/widgets/custom_button.dart';

class QuestBottomInfo extends StatefulWidget {
  final String startDate;
  final int applyCount;
  const QuestBottomInfo({
    super.key,
    required this.startDate,
    required this.applyCount,
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
    return BottomAppBar(
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: Scaler.width(0.85, context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        width: Scaler.width(0.425, context) - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/clock_icon.svg',
                              width: Scaler.width(0.08, context),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '마감까지',
                                  style: TextStyles.questDetailBottomMenuStyle,
                                ),
                                SizedBox(
                                  width: Scaler.width(0.85, context) * 0.5 -
                                      Scaler.width(0.08, context) -
                                      30,
                                  child: Text(
                                    widget.startDate == ''
                                        ? ''
                                        : getRemainingTime(
                                            DateTime.parse(widget.startDate)),
                                    style: TextStyles.questDetailBottomDatatyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: ColorSet.lightGrey,
                    ),
                    InkWell(
                      onTap: () async {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: SizedBox(
                        width: Scaler.width(0.425, context) - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/people_icon.svg',
                              width: Scaler.width(0.08, context),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '실시간 참여자',
                                  style: TextStyles.questDetailBottomMenuStyle,
                                ),
                                Text(
                                  '${widget.applyCount}명',
                                  style: TextStyles.questDetailBottomDatatyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            onPressed: () {},
            width: Scaler.width(0.85, context),
            height: 50,
            child: const Text(
              '참여 신청하기',
              style: TextStyles.loginButtonStyle,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
