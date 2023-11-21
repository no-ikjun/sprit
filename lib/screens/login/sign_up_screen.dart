import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/auth/local_login.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/auth_formatter.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/policy/personal_info.dart';
import 'package:sprit/popups/policy/user_policy.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';
import 'package:sprit/widgets/text_input.dart';

enum SignUpRejection {
  idValidation,
  passwordValidation,
  nicknameValidation,
  agreementValidation,
  checked,
}

SignUpRejection signUpValidation(
  String userId,
  String userPassword,
  String userPasswordConfirm,
  String userNickname,
  List<bool> isAllowed,
) {
  if (!AuthFormatter.isAllowedId(userId)) {
    return SignUpRejection.idValidation;
  }
  if (!AuthFormatter.passwordCheck(userPassword, userPasswordConfirm)) {
    return SignUpRejection.passwordValidation;
  }
  if (!AuthFormatter.isAllowedNickname(userNickname)) {
    return SignUpRejection.nicknameValidation;
  }
  if (!isAllowed[0] || !isAllowed[1]) {
    return SignUpRejection.agreementValidation;
  }
  return SignUpRejection.checked;
}

Future<String> signUp(
  BuildContext context,
  String userId,
  String userPassword,
  String userNickname,
) async {
  return await LocalAuthService.localSignup(
    context,
    CreateUserInfo(
      userId: userId,
      userPassword: userPassword,
      userNickname: userNickname,
    ),
  );
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _userId = '';
  String _userPassword = '';
  String _userPasswordConfirm = '';
  String _userNickname = '';
  final List<bool> _isAllowed = [false, false];
  List<bool> validation = [true, true, true, true];
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
                            Text(
                              validation[0]
                                  ? '아이디를 입력해주세요 (5~12글자)'
                                  : '사용할 수 없는 아이디입니다',
                              style: TextStyles.loginLabel.copyWith(
                                color: validation[0]
                                    ? ColorSet.semiDarkGrey
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '아이디',
                              onChanged: (String value) {
                                setState(() {
                                  _userId = value;
                                });
                              },
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                              autofocus: true,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              validation[1]
                                  ? '비밀번호를 입력해주세요'
                                  : '비밀번호가 일치하지 않습니다',
                              style: TextStyles.loginLabel.copyWith(
                                color: validation[1]
                                    ? ColorSet.semiDarkGrey
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '비밀번호',
                              onChanged: (String value) {
                                setState(() {
                                  _userPassword = value;
                                });
                              },
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Text(
                              validation[1]
                                  ? '비밀번호를 한 번 더입력해주세요'
                                  : '비밀번호가 일치하지 않습니다',
                              style: TextStyles.loginLabel.copyWith(
                                color: validation[1]
                                    ? ColorSet.semiDarkGrey
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '비밀번호 확인',
                              onChanged: (String value) {
                                setState(() {
                                  _userPasswordConfirm = value;
                                });
                              },
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            Text(
                              validation[2]
                                  ? '사용하실 닉네임을 입력해주세요 (2~8글자)'
                                  : '사용할 수 없는 닉네임입니다',
                              style: TextStyles.loginLabel.copyWith(
                                color: validation[2]
                                    ? ColorSet.semiDarkGrey
                                    : Colors.red,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomTextField(
                              hintText: '닉네임',
                              onChanged: (String value) {
                                setState(() {
                                  _userNickname = value;
                                });
                              },
                              width: Scaler.width(0.85, context),
                              height: 50,
                              padding: 15,
                            ),
                            const SizedBox(
                              height: 33,
                            ),
                            Text(
                              validation[3] ? '약관 동의' : '모든 약관에 동의해주세요',
                              style: TextStyles.loginLabel.copyWith(
                                color: validation[3]
                                    ? ColorSet.semiDarkGrey
                                    : Colors.red,
                              ),
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
                              onPressed: () async {
                                setState(() {
                                  validation = [true, true, true, true];
                                });
                                final message = signUpValidation(
                                  _userId,
                                  _userPassword,
                                  _userPasswordConfirm,
                                  _userNickname,
                                  _isAllowed,
                                );
                                if (message == SignUpRejection.idValidation) {
                                  setState(() {
                                    validation[0] = false;
                                  });
                                }
                                if (message ==
                                    SignUpRejection.passwordValidation) {
                                  setState(() {
                                    validation[1] = false;
                                  });
                                }
                                if (message ==
                                    SignUpRejection.nicknameValidation) {
                                  setState(() {
                                    validation[2] = false;
                                  });
                                }
                                if (message ==
                                    SignUpRejection.agreementValidation) {
                                  setState(() {
                                    validation[3] = false;
                                  });
                                }
                                if (validation[0] &&
                                    validation[1] &&
                                    validation[2] &&
                                    validation[3]) {
                                  final token = await signUp(
                                    context,
                                    _userId,
                                    _userPassword,
                                    _userNickname,
                                  );
                                  if (token == '') {
                                    setState(() {
                                      validation[0] = false;
                                    });
                                    return;
                                  }
                                  const storage = FlutterSecureStorage();
                                  await storage.write(
                                    key: "access_token",
                                    value: token,
                                  );
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RouteName.home,
                                    (route) => false,
                                  );
                                }
                              },
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
