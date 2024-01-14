import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

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
                    style: TextStyles.homeNameStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: Scaler.width(0.85, context),
              height: 150,
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
                        width: Scaler.width(0.25, context),
                        height: 150,
                        child: CupertinoPicker(
                          backgroundColor: Colors.transparent,
                          selectionOverlay: null,
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {},
                          children: List<Widget>.generate(
                            7,
                            (int index) {
                              String day;
                              switch (index) {
                                case 0:
                                  day = '월요일';
                                  break;
                                case 1:
                                  day = '화요일';
                                  break;
                                case 2:
                                  day = '수요일';
                                  break;
                                case 3:
                                  day = '목요일';
                                  break;
                                case 4:
                                  day = '금요일';
                                  break;
                                case 5:
                                  day = '토요일';
                                  break;
                                case 6:
                                  day = '일요일';
                                  break;
                                default:
                                  day = '';
                              }
                              return Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}
