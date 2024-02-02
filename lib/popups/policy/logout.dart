import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';

class LogoutConfirm extends StatelessWidget {
  const LogoutConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        const Text(
          '로그아웃',
          style: TextStyles.notificationConfirmModalTitleStyle,
        ),
        const SizedBox(
          height: 14,
        ),
        const Text(
          '정말로 로그아웃 하시겠습니까?',
          style: TextStyles.notificationConfirmModalDescriptionStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: Scaler.width(0.85, context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                color: ColorSet.lightGrey,
                borderColor: ColorSet.lightGrey,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '취소',
                  style: TextStyles.buttonLabelStyle,
                ),
              ),
              CustomButton(
                width: Scaler.width(0.8, context) * 0.5 - 5,
                height: 50,
                onPressed: () async {
                  const storage = FlutterSecureStorage();
                  storage.deleteAll();
                  context.read<UserInfoState>().removeUserInfo();
                  context.read<LibrarySectionOrderState>().removeSectionOrder();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                child: const Text('로그아웃', style: TextStyles.buttonLabelStyle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
