import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/ui/text_styles.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onItemTapped(0);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
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
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onItemTapped(1);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 1
                          ? 'assets/images/bookmark_icon_blue.svg'
                          : 'assets/images/bookmark_icon_grey.svg',
                      height: 26,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '내 서재',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 1)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 1)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 23),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onItemTapped(2);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 2
                          ? 'assets/images/quest_icon_blue.svg'
                          : 'assets/images/quest_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '퀘스트',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 2)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 2)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onItemTapped(3);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      widget.selectedIndex == 3
                          ? 'assets/images/graph_icon_blue.svg'
                          : 'assets/images/graph_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '기록분석',
                      style: TextStyles.bottomAppBarLabelStyle.copyWith(
                        color: (widget.selectedIndex == 3)
                            ? ColorSet.primaryLight
                            : ColorSet.grey,
                        fontWeight: (widget.selectedIndex == 3)
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // 겹쳐지는 원 모양의 버튼
          Positioned(
            top: -15, // 원하는 오프셋으로 조정
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                // 원 모양 버튼 클릭 시 액션
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
