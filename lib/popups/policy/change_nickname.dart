import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

class ChangeNickname extends StatefulWidget {
  final String nickname;
  final Function callback;
  const ChangeNickname({
    super.key,
    required this.nickname,
    required this.callback,
  });

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  String _nickname = '';
  bool isRefused = false;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
  }

  @override
  Widget build(BuildContext context) {
    return isChanged
        ? SizedBox(
            width: Scaler.width(0.85, context),
            height: 80,
            child: const Center(
              child: Text(
                '닉네임이 변경되었습니다',
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
                '닉네임 변경',
                style: TextStyles.notificationConfirmModalTitleStyle,
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                isRefused ? '닉네임은 2~8글자로 입력해주세요' : '변경할 닉네임을 입력하세요',
                style: TextStyles.notificationConfirmModalDescriptionStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: '닉네임',
                onChanged: (String value) {
                  _nickname = value;
                },
                width: Scaler.width(0.8, context),
                height: 50,
                padding: 15,
                defaultText: widget.nickname,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomButton(
                onPressed: () async {
                  if (_nickname.length < 2 || _nickname.length > 8) {
                    setState(() {
                      isRefused = true;
                    });
                    return;
                  } else {
                    await UserInfoService.changeNickname(_nickname);
                    setState(() {
                      isChanged = true;
                    });
                    context.read<UserInfoState>().updateNickname(_nickname);
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
