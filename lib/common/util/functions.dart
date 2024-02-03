import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/widgets/modal.dart';

showModal(BuildContext context, Widget content, bool closeButton) async {
  await showDialog<String>(
    context: context,
    builder: (context) => Modal(
      content: content,
      closeButton: closeButton,
    ),
  );
}

getColorForValue(int value, int maxValue) {
  double step = (maxValue > 0 ? maxValue : 1) / 5;
  if (value == 0) return GrassColor.grassDefault;
  if (value <= step) return GrassColor.grass1st;
  if (value <= step * 2) return GrassColor.grass2nd;
  if (value <= step * 3) return GrassColor.grass3rd;
  if (value <= step * 4) return GrassColor.grass4th;
  return GrassColor.grass5th;
}

getFormattedTime(int time) {
  if (time == 0) return '';
  if (time < 60) return '($time초)';
  if (time < 3600) return '(${(time / 60).floor()}분)';
  if (time < 86400) {
    return '(${(time / 3600).toStringAsFixed(1)}시간)';
  }
}
