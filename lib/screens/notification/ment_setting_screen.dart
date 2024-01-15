import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/notification/widgets/remind_ment.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';

class MentSettingScreen extends StatefulWidget {
  const MentSettingScreen({super.key});

  @override
  State<MentSettingScreen> createState() => _MentSettingScreenState();
}

class _MentSettingScreenState extends State<MentSettingScreen> {
  final int _selectedSectionIndex = 1;
  final int _selectedTimeIndex = 0;
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
                              '리마인드 문구 선택 💬',
                              style:
                                  TextStyles.notificationTimeSettingTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const RemindMentWidget(),
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
