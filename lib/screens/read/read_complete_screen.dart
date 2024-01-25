import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class ReadCompleteScreen extends StatelessWidget {
  const ReadCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: const Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        body: SafeArea(
          maintainBottomViewPadding: false,
          child: Column(
            children: [
              CustomAppBar(
                label: '독서 기록',
                onlyLabel: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
