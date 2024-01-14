import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';

class TimeSettingScreen extends StatefulWidget {
  const TimeSettingScreen({super.key});

  @override
  State<TimeSettingScreen> createState() => _TimeSettingScreenState();
}

class _TimeSettingScreenState extends State<TimeSettingScreen> {
  int _selectedSectionIndex = 0;
  int _selectedTimeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            const CustomAppBar(
              label: "알림 설정",
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '독서 시간 알림 설정 ⏰',
                              style:
                                  TextStyles.notificationTimeSettingTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: Scaler.width(0.85, context),
                        height: 170,
                        decoration: BoxDecoration(
                          color: ColorSet.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: const Offset(0, 4),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: Scaler.width(0.80, context),
                              height: 32,
                              decoration: BoxDecoration(
                                color: CupertinoColors.tertiarySystemFill,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Scaler.width(0.2, context),
                                  height: 150,
                                  child: CupertinoPicker(
                                    backgroundColor: Colors.transparent,
                                    selectionOverlay: null,
                                    itemExtent: 32.0,
                                    onSelectedItemChanged: (int index) {
                                      setState(() {
                                        _selectedSectionIndex = index;
                                      });
                                    },
                                    children: const <Widget>[
                                      Center(child: Text('오전')),
                                      Center(child: Text('오후')),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: Scaler.width(0.25, context),
                                  height: 150,
                                  child: CupertinoPicker(
                                    backgroundColor: Colors.transparent,
                                    selectionOverlay: null,
                                    itemExtent: 32.0,
                                    onSelectedItemChanged: (int index) {
                                      setState(() {
                                        _selectedTimeIndex = index;
                                      });
                                    },
                                    children:
                                        List<Widget>.generate(12, (int index) {
                                      return Center(
                                          child: Text('${index + 1} : 00'));
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              onPressed: () {},
                              width: Scaler.width(0.85 * 0.4, context) - 5,
                              color: ColorSet.lightGrey,
                              borderColor: ColorSet.lightGrey,
                              child: const Text(
                                '초기화',
                                style: TextStyles.loginButtonStyle,
                              ),
                            ),
                            CustomButton(
                              onPressed: () {},
                              width: Scaler.width(0.85 * 0.6, context) - 5,
                              child: const Text(
                                '적용하기',
                                style: TextStyles.loginButtonStyle,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/information_grey_icon.svg',
                              width: 14,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              '독서 시간 알림은 하루에 한 번씩 발송됩니다.',
                              style: TextStyles
                                  .notificationTimeSettingInformationStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
