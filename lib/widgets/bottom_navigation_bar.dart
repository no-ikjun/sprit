import 'package:flutter/material.dart';
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
                  widget.onItemTapped(0);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/images/home_icon_grey.svg',
                      height: 26,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '홈',
                      style: TextStyles.bottomAppBarLabelStyle,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onItemTapped(1);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/images/bookmark_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '책갈피',
                      style: TextStyles.bottomAppBarLabelStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 25),
              InkWell(
                onTap: () {
                  widget.onItemTapped(2);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/images/magnifier_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '찾아보기',
                      style: TextStyles.bottomAppBarLabelStyle,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  widget.onItemTapped(3);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/images/graph_icon_grey.svg',
                      height: 24,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '기록분석',
                      style: TextStyles.bottomAppBarLabelStyle,
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
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorSet.primary,
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
