import 'package:flutter/material.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '스프릿',
                                style: TextStyles.loginTitle.copyWith(
                                  color: ColorSet.primary,
                                ),
                              ),
                              const Text(
                                '과 함께',
                                style: TextStyles.loginTitle,
                              ),
                            ],
                          ),
                          const Text(
                            '독서를 시작해볼까요?',
                            style: TextStyles.loginTitle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: Scaler.width(0.85, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '먼저, 로그인이 필요해요',
                        style: TextStyles.loginLabel,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomTextField(
                        hintText: '아이디',
                        onChanged: (String value) {},
                        width: Scaler.width(0.85, context),
                        height: 50,
                        padding: 15,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      CustomTextField(
                        hintText: '비밀번호',
                        obscureText: true,
                        onChanged: (String value) {},
                        width: Scaler.width(0.85, context),
                        height: 50,
                        padding: 15,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onPressed: () {},
                        width: Scaler.width(0.85, context),
                        height: 45,
                        child: const Text(
                          '로그인',
                          style: TextStyles.loginButtonStyle,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {},
                            child: const Text(
                              '',
                              style: TextStyles.loginLabel,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              Navigator.pushNamed(context, RouteName.signUp);
                            },
                            child: Column(
                              children: [
                                Text(
                                  '아직 회원이 아니신가요?',
                                  style: TextStyles.loginLabel.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Divider(
                              color: ColorSet.semiDarkGrey,
                              thickness: 1,
                            ),
                            Container(
                              width: 100,
                              height: 20,
                              color: ColorSet.background,
                              child: const Center(
                                child: Text(
                                  '간편로그인',
                                  style: TextStyles.loginLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomButton(
                        onPressed: () {},
                        width: Scaler.width(0.85, context),
                        height: 45,
                        color: const Color(0xFFFEE500),
                        borderColor: const Color(0xFFFEE500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/kakao_logo.png',
                              width: 18,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '카카오 로그인',
                              style: TextStyles.loginButtonStyle.copyWith(
                                color: ColorSet.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomButton(
                        onPressed: () {},
                        width: Scaler.width(0.85, context),
                        height: 45,
                        color: const Color(0xFF000000),
                        borderColor: const Color(0xFF000000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/apple_logo.png',
                              width: 16,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Apple로 로그인',
                              style: TextStyles.loginButtonStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
