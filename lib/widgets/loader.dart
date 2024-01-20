import 'package:flutter/material.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.color = ColorSet.darkGrey,
    this.loadingTxt = '정보 불러오는 중...',
  });
  final Color color;
  final String loadingTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
          child: Container(
        padding: const EdgeInsets.only(
          bottom: 18,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'assets/images/loading_animation.gif',
                    width: 60,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    loadingTxt,
                    style: TextStyles.loaderText,
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
