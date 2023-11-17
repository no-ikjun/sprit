import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Color borderColor;
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.color = ColorSet.primary,
    this.width = 300,
    this.height = 50,
    this.borderRadius = 8,
    this.borderColor = ColorSet.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
