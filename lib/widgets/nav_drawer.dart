import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Scaler.width(0.65, context),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Scaler.width(0.075, context),
                vertical: Scaler.height(0.01, context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          color: ColorSet.grey,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/bell_icon.svg',
                              height: 18,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            const Text(
                              '공지사항',
                              style: TextStyles.navDrawerLabelStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/setting_icon.svg',
                          width: 17,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          '환경설정',
                          style: TextStyles.navDrawerLabelStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/info_icon.svg',
                          width: 17,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          '회원정보 확인',
                          style: TextStyles.navDrawerLabelStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/chat_icon.svg',
                          width: 17,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          '문의하기',
                          style: TextStyles.navDrawerLabelStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      const storage = FlutterSecureStorage();
                      storage.deleteAll();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/logout_icon.svg',
                          width: 17,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          '로그아웃',
                          style: TextStyles.navDrawerLabelStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
