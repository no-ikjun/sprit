import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

class ChangePassword extends StatefulWidget {
  final Function callback;
  const ChangePassword({
    super.key,
    required this.callback,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isRefused = false;
  bool isChanged = false;

  String newPassword = '';
  String newPasswordConfirm = '';

  @override
  Widget build(BuildContext context) {
    return isChanged
        ? SizedBox(
            width: Scaler.width(0.85, context),
            height: 80,
            child: const Center(
              child: Text(
                '비밀번호가 변경되었습니다',
                style: TextStyles.notificationConfirmModalDescriptionStyle,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                '비밀번호 변경',
                style: TextStyles.notificationConfirmModalTitleStyle,
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                isRefused ? '비밀번호가 서로 일치하지 않아요' : '변경할 비밀번호를 입력하세요',
                style: TextStyles.notificationConfirmModalDescriptionStyle
                    .copyWith(
                  color: isRefused ? ColorSet.red : ColorSet.text,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: '새 비밀번호',
                obscureText: true,
                onChanged: (String value) {
                  newPassword = value;
                },
                width: Scaler.width(0.8, context),
                height: 50,
                padding: 15,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextField(
                hintText: '비밀번호 확인',
                obscureText: true,
                onChanged: (String value) {
                  newPassword = value;
                },
                width: Scaler.width(0.8, context),
                height: 50,
                padding: 15,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomButton(
                onPressed: () async {
                  if (newPassword != newPasswordConfirm) {
                    setState(() {
                      isRefused = true;
                    });
                    return;
                  } else {
                    await UserInfoService.changePassword(context, newPassword);
                    setState(() {
                      isChanged = true;
                    });
                    Future.delayed(const Duration(milliseconds: 400), () {
                      Navigator.pop(context);
                    });
                  }
                },
                width: Scaler.width(0.85, context),
                height: 45,
                child: const Text(
                  '변경하기',
                  style: TextStyles.loginButtonStyle,
                ),
              ),
            ],
          );
  }
}
