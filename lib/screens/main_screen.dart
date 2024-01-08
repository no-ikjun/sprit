import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/screens/home/home_screen.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/widgets/bottom_navigation_bar.dart';

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
        return const Text('Search Tab');
      case 2:
        return const SearchScreen(
          isHome: true,
        );
      case 3:
        return const Text('Profile Tab');
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
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorSet.background,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
        body: Consumer<NavigationProvider>(
          // `Consumer`를 사용하여 선택된 인덱스에 따라 `body`를 업데이트
          builder: (context, navigationProvider, child) {
            return _getTabWidget(navigationProvider.selectedIndex);
          },
        ),
      ),
    );
  }
}
