import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';

class TextStyles {
  static const TextStyle appBarLabel = TextStyle(
    color: ColorSet.text,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle loginTitle = TextStyle(
    color: ColorSet.text,
    fontSize: 25,
    fontWeight: FontWeight.w800,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle loginLabel = TextStyle(
    color: ColorSet.semiDarkGrey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle textHintStyle = TextStyle(
    color: ColorSet.grey,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle textInputStyle = TextStyle(
    color: ColorSet.text,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle loginButtonStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );
}
