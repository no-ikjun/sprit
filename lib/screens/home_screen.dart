import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              CustomAppBar(
                isHomeScreen: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
