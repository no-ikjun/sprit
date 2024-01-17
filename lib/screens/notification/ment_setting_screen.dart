import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/screens/notification/widgets/remind_ment.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/remove_glow.dart';

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
              child: ScrollConfiguration(
                behavior: RemoveGlow(),
                child: SingleChildScrollView(
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
                                  style: TextStyles
                                      .notificationTimeSettingTitleStyle,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RemindMentWidget(
                            title: '역행자',
                            description: '선택. 집중. 몰입 대상을 정하자. "나는 ~ 한 사람이야.',
                            switchValue: true,
                            onToggle: () {},
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          RemindMentWidget(
                            title: '돈의 심리학',
                            description: '성공을 위한 비용을 기꺼이 지불하라',
                            switchValue: true,
                            onToggle: () {},
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: Scaler.width(0.85, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  onPressed: () {},
                                  width: Scaler.width(0.85 * 0.4, context) - 5,
                                  height: 45,
                                  color: ColorSet.lightGrey,
                                  borderColor: ColorSet.lightGrey,
                                  child: const Text(
                                    '모두 선택',
                                    style: TextStyles.loginButtonStyle,
                                  ),
                                ),
                                CustomButton(
                                  onPressed: () {},
                                  width: Scaler.width(0.85 * 0.6, context) - 5,
                                  height: 45,
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
                          const SizedBox(
                            height: 18,
                          ),
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
                                  '리마인드 알림은 일주일에 최대 두 번 발송됩니다',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
