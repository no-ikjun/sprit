import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/policy/personal_info.dart';
import 'package:sprit/popups/policy/user_policy.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<bool> _isAllowed = [false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.background,
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(
              label: '회원가입',
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Scaler.width(0.85, context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '아이디를 입력해주세요',
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
                              autofocus: true,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            const Text(
                              '비밀번호를 입력해주세요',
                              style: TextStyles.loginLabel,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '비밀번호',
                              onChanged: (String value) {},
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            const Text(
                              '비밀번호를 한 번 더 입력해주세요',
                              style: TextStyles.loginLabel,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '비밀번호 확인',
                              onChanged: (String value) {},
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            const Text(
                              '사용하실 닉네임을 입력하세요',
                              style: TextStyles.loginLabel,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '닉네임',
                              onChanged: (String value) {},
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            const Text(
                              '약관 동의',
                              style: TextStyles.loginLabel,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isAllowed[0] = !_isAllowed[0];
                                    });
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: SvgPicture.asset(
                                    _isAllowed[0]
                                        ? 'assets/images/check_blue.svg'
                                        : 'assets/images/check_grey.svg',
                                    width: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await showModal(
                                      context,
                                      const UserPolicyWidget(),
                                      false,
                                    );
                                    setState(() {
                                      _isAllowed[0] = true;
                                    });
                                  },
                                  child: const Text(
                                    '스프릿 이용약관 동의 (필수)',
                                    style: TextStyles.signUpLabel,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isAllowed[1] = !_isAllowed[1];
                                    });
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: SvgPicture.asset(
                                    _isAllowed[1]
                                        ? 'assets/images/check_blue.svg'
                                        : 'assets/images/check_grey.svg',
                                    width: 16,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                InkWell(
                                  onTap: () async {
                                    await showModal(
                                      context,
                                      const PersonalInfoWidget(),
                                      false,
                                    );
                                    setState(() {
                                      _isAllowed[1] = true;
                                    });
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: const Text(
                                    '개인정보 수집 및 이용 동의 (필수)',
                                    style: TextStyles.signUpLabel,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            CustomButton(
                              onPressed: () {},
                              width: Scaler.width(0.85, context),
                              height: 45,
                              child: const Text(
                                '가입하기',
                                style: TextStyles.loginButtonStyle,
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
          ],
        ),
      ),
    );
  }
}
