import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          children: [
            CustomAppBar(
              label: '알림 설정',
            ),
          ],
        ),
      ),
    );
  }
}
