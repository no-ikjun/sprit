import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';

class CustomToggleButton extends StatefulWidget {
  final double width;
  final double height;
  final double padding;
  final double radius;
  final double leftAlign;
  final double rightAlign;
  final Color selectedColor;
  final Color normalColor;
  final Color selectedTextColor;
  final Color normalTextColor;
  final Function onLeftTap;
  final Function onRightTap;
  final Widget leftText;
  final Widget rightText;
  final double leftWidth;
  final double rightWidth;

  const CustomToggleButton({
    super.key,
    required this.width,
    required this.height,
    required this.padding,
    required this.radius,
    required this.onLeftTap,
    required this.onRightTap,
    required this.leftText,
    required this.rightText,
    this.leftAlign = -1,
    this.rightAlign = 1,
    this.selectedColor = ColorSet.white,
    this.normalColor = ColorSet.superLightGrey,
    this.selectedTextColor = ColorSet.darkGrey,
    this.normalTextColor = ColorSet.darkGrey,
    this.leftWidth = 0.5,
    this.rightWidth = 0.5,
  });

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  double xAlign = 0;
  Color leftColor = ColorSet.primary;
  Color rightColor = const Color(0xfff4f5f7);

  @override
  void initState() {
    super.initState();
    xAlign = widget.leftAlign;
    leftColor = widget.selectedColor;
    rightColor = widget.normalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.normalColor,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(
              milliseconds: 120,
            ),
            child: Container(
              width: (xAlign == widget.leftAlign)
                  ? widget.width * widget.leftWidth
                  : widget.width * widget.rightWidth,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.selectedColor,
                borderRadius:
                    BorderRadius.circular(widget.radius - widget.padding),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onLeftTap();
              setState(() {
                xAlign = widget.leftAlign;
                leftColor = widget.selectedColor;
                rightColor = widget.normalColor;
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: widget.width * widget.leftWidth,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: widget.leftText,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.onRightTap();
              setState(() {
                xAlign = widget.rightAlign;
                leftColor = widget.normalColor;
                rightColor = widget.selectedColor;
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: widget.width * widget.rightWidth,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: widget.rightText,
              ),
            ),
          )
        ],
      ),
    );
  }
}
