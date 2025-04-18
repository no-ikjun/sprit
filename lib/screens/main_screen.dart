import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprit/amplitude_service.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/analytics/analytics_screen.dart';
import 'package:sprit/screens/home/home_screen.dart';
import 'package:sprit/screens/library/my_library_screen.dart';
import 'package:sprit/screens/social/social_screen.dart';
import 'package:sprit/widgets/bottom_navigation_bar.dart';
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
        return const AnalyticsScreen();
      case 2:
        return const SocialScreen();
      case 3:
        return const MyLibraryScreen();
      default:
        return const Text('Other Tab');
    }
  }

  @override
  void initState() {
    super.initState();
    AmplitudeService().logEvent(
      'Sign Up',
      properties: {
        'userUuid': context.read<UserInfoState>().userInfo.userUuid,
      },
    );
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
        bottomNavigationBar: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 90,
          ),
          child: Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
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
