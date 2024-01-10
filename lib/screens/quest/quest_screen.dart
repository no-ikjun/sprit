import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_app_bar.dart';

class QuestScreen extends StatelessWidget {
  const QuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Column(
        children: [
          CustomAppBar(
            isHomeScreen: true,
            logoShown: false,
            onlyLabel: false,
            rightIcons: [
              IconButton(
                iconSize: 30,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                padding: EdgeInsets.only(right: Scaler.width(0.075, context)),
                icon: SvgPicture.asset(
                  'assets/images/plus_icon.svg',
                  width: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ],
          ),
          SizedBox(
            width: Scaler.width(0.85, context),
            child: const Text(
              '스프릿 퀘스트',
              style: TextStyles.questScreenTitleStyle,
            ),
          ),
        ],
      ),
    );
  }
}
