import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sprit/common/ui/color_set.dart';

class CustomSwitch extends StatelessWidget {
  final Function() onToggle;
  final bool switchValue;
  final double width;
  final double height;
  final double padding;
  final double toggleSize;
  const CustomSwitch({
    Key? key,
    required this.onToggle,
    required this.switchValue,
    this.width = 44,
    this.height = 26,
    this.padding = 3,
    this.toggleSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: width,
      height: height,
      padding: padding,
      toggleSize: toggleSize,
      value: switchValue,
      onToggle: (value) async {
        onToggle();
      },
      activeColor: ColorSet.primary,
      inactiveColor: const Color(0xFFD6D6D6),
    );
  }
}
