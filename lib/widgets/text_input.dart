import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final double width;
  final double height;
  final double padding;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final int maxLines;
  final int maxLength;
  final String defaultText;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.width = 300,
    this.height = 40,
    this.padding = 10,
    this.borderColor = ColorSet.lightGrey,
    this.focusedBorderColor = ColorSet.primary,
    this.borderRadius = 8,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength = 100,
    this.defaultText = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: TextEditingController()..text = defaultText,
        autofocus: autofocus,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: [LengthLimitingTextInputFormatter(maxLength)],
        maxLines: maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: padding,
          ),
          hintText: hintText,
          hintStyle: TextStyles.textHintStyle,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
        cursorColor: Colors.black,
        textAlign: textAlign,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyles.textInputStyle,
      ),
    );
  }
}
