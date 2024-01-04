import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';

class TextStyles {
  static const TextStyle appBarLabel = TextStyle(
    color: ColorSet.text,
    fontSize: 18,
    fontWeight: FontWeight.w600,
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

  static const TextStyle signUpLabel = TextStyle(
    color: ColorSet.darkGrey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
    decoration: TextDecoration.underline,
  );

  static const TextStyle policyStyle = TextStyle(
    color: ColorSet.text,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle homeNameStyle = TextStyle(
    color: ColorSet.text,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle homeButtonTitleStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: "IBMPlexSans",
  );

  static const TextStyle homeButtonLabelStyle = TextStyle(
    color: Color(0xFF979797),
    fontSize: 10,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
    letterSpacing: -0.2,
  );

  static const TextStyle textFieldStyle = TextStyle(
    color: ColorSet.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: "IBMPlexSans",
  );
}
