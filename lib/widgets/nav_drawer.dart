import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:scaler/scaler.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/util/functions.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/popups/policy/logout.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Scaler.width(0.66, context),
      elevation: 0,
      backgroundColor: ColorSet.white,
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
                    onTap: () {
                      AmplitudeService().logEvent(
                        AmplitudeEvent.drawerNoticeClick,
                        context.read<UserInfoState>().userInfo.userUuid,
                      );
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteName.notice);
                    },
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
                  // const SizedBox(
                  //   height: 23,
                  // ),
                  // InkWell(
                  //   highlightColor: Colors.transparent,
                  //   splashColor: Colors.transparent,
                  //   onTap: () {},
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset(
                  //         'assets/images/setting_icon.svg',
                  //         width: 17,
                  //       ),
                  //       const SizedBox(
                  //         width: 15,
                  //       ),
                  //       const Text(
                  //         '환경설정',
                  //         style: TextStyles.navDrawerLabelStyle,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      AmplitudeService().logEvent(
                        AmplitudeEvent.drawerProfileClick,
                        context.read<UserInfoState>().userInfo.userUuid,
                      );
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RouteName.profile);
                    },
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
                    onTap: () {
                      AmplitudeService().logEvent(
                        AmplitudeEvent.drawerQuestionClick,
                        context.read<UserInfoState>().userInfo.userUuid,
                      );
                      Uri url = Uri(
                        scheme: 'mailto',
                        path: "sprit@ikjun.com",
                        queryParameters: {
                          'subject': 'SPRIT문의',
                          'body': '',
                        },
                      );
                      Navigator.pop(context);
                      launchUrl(url);
                    },
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
                      AmplitudeService().logEvent(
                        AmplitudeEvent.drawerLogoutClick,
                        context.read<UserInfoState>().userInfo.userUuid,
                      );
                      showModal(context, const LogoutConfirm(), false);
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
