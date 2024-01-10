import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/screens/home/home_screen.dart';
import 'package:sprit/screens/quest/quest_screen.dart';
import 'package:sprit/widgets/bottom_navigation_bar.dart';
import 'package:sprit/widgets/custom_app_bar.dart';
import 'package:sprit/widgets/nav_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _getTabWidget(int index) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const CustomAppBar(
          onlyLabel: true,
          label: '내 서재',
        );
      case 2:
        return const QuestScreen();
      case 3:
        return const CustomAppBar(
          onlyLabel: true,
          label: '기록분석',
        );
      default:
        return const Text('Other Tab');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: ColorSet.background,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        endDrawer: const NavDrawer(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorSet.primary.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: CustomBottomNavigationBar(
            selectedIndex: navigationProvider.selectedIndex,
            onItemTapped: navigationProvider.selectTab,
          ),
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: ColorSet.background,
          ),
          child: Consumer<NavigationProvider>(
            builder: (context, navigationProvider, child) {
              return _getTabWidget(navigationProvider.selectedIndex);
            },
          ),
        ),
      ),
    );
  }
}
