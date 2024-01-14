import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final int _selectedMonthIndex = 0;
  final int _selectedDayIndex = 0;
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
            SizedBox(
              width: Scaler.width(0.85, context),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '독서 시간 알림 설정 ⏰',
                    style: TextStyles.notificationTimeSettingTitleStyle,
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
                            // Handle AM/PM change
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
                            // Handle hour change
                          },
                          children: List<Widget>.generate(12, (int index) {
                            return Center(child: Text('${index + 1} : 00'));
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
      ),
    );
  }
}
