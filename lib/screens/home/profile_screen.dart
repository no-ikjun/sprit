import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/apis/services/user_info.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/popups/policy/change_nickname.dart';
import 'package:sprit/popups/policy/change_password.dart';
import 'package:sprit/popups/policy/delete_user.dart';
import 'package:sprit/popups/policy/logout.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/custom_button.dart';

Future<UserInfoAll> getUserInfoAll(BuildContext context) async {
  return await UserInfoService.getUserInfoAll(context);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserInfoAll userInfoAll = const UserInfoAll(
    userUuid: '',
    userNickame: '',
    userId: '',
    registerType: '',
    registeredAt: '',
  );
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getUserInfoAll(context).then((value) {
      setState(() {
        userInfoAll = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorSet.background,
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomAppBar(
              label: '회원정보',
            ),
            Expanded(
              child: SingleChildScrollView(
                child: isLoading
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Center(
                            child: CupertinoActivityIndicator(
                              radius: 20,
                              animating: true,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          Text(
                            '닉네임',
                            style: TextStyles.loginLabel.copyWith(
                              color: ColorSet.semiDarkGrey,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: Scaler.width(0.85, context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: ColorSet.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorSet.lightGrey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context
                                      .watch<UserInfoState>()
                                      .userInfo
                                      .userNickname,
                                  style: TextStyles
                                      .myLibraryBookReportButtonStyle
                                      .copyWith(
                                    color: ColorSet.text,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModal(
                                      context,
                                      ChangeNickname(
                                        nickname: context
                                            .read<UserInfoState>()
                                            .userInfo
                                            .userNickname,
                                        callback: () {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          getUserInfoAll(context).then((value) {
                                            setState(() {
                                              userInfoAll = value;
                                              isLoading = false;
                                            });
                                          });
                                        },
                                      ),
                                      false,
                                    );
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '닉네임 변경',
                                        style: TextStyles
                                            .myLibraryBookReportButtonStyle,
                                      ),
                                      SvgPicture.asset(
                                        'assets/images/right_arrow_grey.svg',
                                        width: 18,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            userInfoAll.registerType == "LOCAL"
                                ? '비밀번호'
                                : '소셜 로그인',
                            style: TextStyles.loginLabel.copyWith(
                              color: ColorSet.semiDarkGrey,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: Scaler.width(0.85, context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: ColorSet.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorSet.lightGrey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                userInfoAll.registerType == "LOCAL"
                                    ? Container()
                                    : Text(
                                        userInfoAll.registerType == "APPLE"
                                            ? "Apple"
                                            : "카카오",
                                        style: TextStyles
                                            .myLibraryBookReportButtonStyle
                                            .copyWith(
                                          color: ColorSet.text,
                                        ),
                                      ),
                                userInfoAll.registerType == "LOCAL"
                                    ? InkWell(
                                        onTap: () {
                                          showModal(
                                            context,
                                            ChangePassword(callback: () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              getUserInfoAll(context).then(
                                                (value) {
                                                  setState(() {
                                                    userInfoAll = value;
                                                    isLoading = false;
                                                  });
                                                },
                                              );
                                            }),
                                            false,
                                          );
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              '비밀번호 변경',
                                              style: TextStyles
                                                  .myLibraryBookReportButtonStyle,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/right_arrow_grey.svg',
                                              width: 18,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            '가입일',
                            style: TextStyles.loginLabel.copyWith(
                              color: ColorSet.semiDarkGrey,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: Scaler.width(0.85, context),
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: ColorSet.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorSet.lightGrey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  userInfoAll.registeredAt.substring(0, 10),
                                  style: TextStyles
                                      .myLibraryBookReportButtonStyle
                                      .copyWith(
                                    color: ColorSet.text,
                                  ),
                                ),
                                Container()
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomButton(
                            onPressed: () {
                              showModal(context, const LogoutConfirm(), false);
                            },
                            width: Scaler.width(0.85, context),
                            height: 45,
                            color: ColorSet.lightGrey,
                            borderColor: ColorSet.lightGrey,
                            child: const Text(
                              '로그아웃',
                              style: TextStyles.loginButtonStyle,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            InkWell(
              onTap: () {
                showModal(context, const DeleteUser(), false);
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '회원 탈퇴',
                    style: TextStyles.myLibraryBookReportButtonStyle,
                  ),
                  SvgPicture.asset(
                    'assets/images/right_arrow_grey.svg',
                    width: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
