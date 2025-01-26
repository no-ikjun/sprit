import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';
import 'package:sprit/common/value/amplitude_events.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/widgets/scalable_inkwell.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 6.0,
      padding: EdgeInsets.zero,
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ScalableInkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.menuHomeClick,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  widget.onItemTapped(0);
                },
                scale: 0.85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 0
                          ? 'assets/images/home_icon_blue.svg'
                          : 'assets/images/home_icon_grey.svg',
                      height: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '홈',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 0)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 0)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              ScalableInkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.menuAnalyticsClick,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  widget.onItemTapped(1);
                },
                scale: 0.85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 1
                          ? 'assets/images/graph_icon_blue.svg'
                          : 'assets/images/graph_icon_grey.svg',
                      height: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '독서기록',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 1)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 1)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              const SizedBox(width: 23),
              ScalableInkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.menuSocialClick,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  widget.onItemTapped(2);
                },
                scale: 0.85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 2
                          ? 'assets/images/social_icon_blue.svg'
                          : 'assets/images/social_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '소셜',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 2)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 2)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              ScalableInkWell(
                onTap: () {
                  AmplitudeService().logEvent(
                    AmplitudeEvent.menuLibraryClick,
                    context.read<UserInfoState>().userInfo.userUuid,
                  );
                  widget.onItemTapped(3);
                },
                scale: 0.85,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 3
                          ? 'assets/images/bookmark_icon_blue.svg'
                          : 'assets/images/bookmark_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '내 서재',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 3)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 3)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: -10,
            child: ScalableInkWell(
              onTap: () {
                AmplitudeService().logEvent(
                  AmplitudeEvent.menuRecordClick,
                  context.read<UserInfoState>().userInfo.userUuid,
                );
                Navigator.pushNamed(
                  context,
                  RouteName.recordSetting,
                  arguments: '',
                );
              },
              child: Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorSet.primary,
                  boxShadow: [
                    BoxShadow(
                      color: ColorSet.primary.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/images/timer_icon.svg',
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
