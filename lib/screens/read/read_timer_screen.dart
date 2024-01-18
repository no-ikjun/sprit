import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class ReadTimerScreen extends StatelessWidget {
  final String bookUuid;
  const ReadTimerScreen({super.key, required this.bookUuid});

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
              label: '독서 기록',
            ),
          ],
        ),
      ),
    );
  }
}
