import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class CustomAppBar extends StatelessWidget {
  final String label;
  final bool isHomeScreen;
  final Widget leftIcon;
  final List<Widget> rightIcons;
  final bool onlyLabel;
  final bool logoShown;

  const CustomAppBar({
    super.key,
    this.label = '',
    this.isHomeScreen = false,
    this.leftIcon = const Icon(
      Icons.arrow_back_ios,
      color: Color(0xff7c7c7c),
      size: 20,
    ),
    this.rightIcons = const [],
    this.onlyLabel = false,
    this.logoShown = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      leadingWidth: isHomeScreen
          ? 69 + Scaler.width(0.075, context)
          : 30 + Scaler.width(0.075, context),
      leading: onlyLabel
          ? Container()
          : isHomeScreen
              ? logoShown
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: Scaler.width(0.075, context)),
                      child: SvgPicture.asset(
                        'assets/images/app_bar_icon.svg',
                        width: 69,
                        height: 30,
                      ),
                    )
                  : Container()
              : IconButton(
                  iconSize: 20,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.only(left: 20),
                  icon: leftIcon,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
      title: Text(
        label,
        style: TextStyles.appBarLabel,
      ),
      actions: onlyLabel
          ? [Container()]
          : isHomeScreen
              ? rightIcons
              : [],
    );
  }
}
