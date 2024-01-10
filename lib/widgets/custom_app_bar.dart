import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class CustomAppBar extends StatelessWidget {
  final String label;
  final bool isHomeScreen;
  final Widget iconData;
  final bool onlyLabel;

  const CustomAppBar({
    super.key,
    this.label = '',
    this.isHomeScreen = false,
    this.iconData = const Icon(
      Icons.arrow_back_ios,
      color: Color(0xff7c7c7c),
      size: 20,
    ),
    this.onlyLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: ColorSet.background,
      elevation: 0,
      leadingWidth: isHomeScreen
          ? 69 + Scaler.width(0.075, context)
          : 30 + Scaler.width(0.075, context),
      leading: onlyLabel
          ? Container()
          : isHomeScreen
              ? Padding(
                  padding: EdgeInsets.only(left: Scaler.width(0.075, context)),
                  child: SvgPicture.asset(
                    'assets/images/app_bar_icon.svg',
                    width: 69,
                    height: 30,
                  ),
                )
              : IconButton(
                  iconSize: 20,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.only(left: 20),
                  icon: iconData,
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
              ? [
                  IconButton(
                    iconSize: 30,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding:
                        EdgeInsets.only(right: Scaler.width(0.075, context)),
                    icon: SvgPicture.asset(
                      'assets/images/hamburger_icon.svg',
                      width: 30,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ]
              : [],
    );
  }
}
