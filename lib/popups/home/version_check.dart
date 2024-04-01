import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheck extends StatelessWidget {
  final List<String> functions;
  const VersionCheck({super.key, required this.functions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '스프릿 신규 버전 출시',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        const Text(
          '스프릿의 신규 버전이 출시되었습니다.\n업데이트 후 신규 기능을 사용해보세요.',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(functions.length, (index) {
            if (functions[index] == "") {
              return Container();
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorSet.darkGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  functions[index],
                  style: TextStyles.notificationConfirmModalDescriptionStyle,
                ),
              ],
            );
          }),
        ),
        const SizedBox(
          height: 18,
        ),
        CustomButton(
          onPressed: () {
            if (Platform.isAndroid) {
              String url =
                  "https://play.google.com/store/apps/details?id=com.ikjunchoi_android.sprit";
              Uri uri = Uri.parse(url);
              launchUrl(uri);
            } else if (Platform.isIOS) {
              String url =
                  "https://apps.apple.com/us/app/%EC%8A%A4%ED%94%84%EB%A6%BF-%EA%BE%B8%EC%A4%80%ED%95%9C-%EB%8F%85%EC%84%9C%EC%8A%B5%EA%B4%80-%EB%A7%8C%EB%93%A4%EA%B8%B0/id6475924225";
              Uri uri = Uri.parse(url);
              launchUrl(uri);
            }
            Navigator.pop(context);
          },
          width: Scaler.width(0.85, context),
          height: 45,
          color: ColorSet.primary,
          borderColor: ColorSet.primary,
          child: const Text(
            '업데이트하기',
            style: TextStyles.loginButtonStyle,
          ),
        ),
      ],
    );
  }
}
