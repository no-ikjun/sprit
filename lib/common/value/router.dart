import 'package:flutter/material.dart';
import 'package:sprit/screens/main_screen.dart';
import 'package:sprit/screens/login/login_screen.dart';
import 'package:sprit/screens/login/sign_up_screen.dart';
import 'package:sprit/screens/search/search_screen.dart';
import 'package:sprit/screens/splash/splash_screen.dart';

class RouteName {
  static const splash = "/";
  static const home = "/home";
  static const login = "/login";
  static const signUp = "/signUp";
  static const search = "/search";
  static const bookDetail = "/bookDetail";
}

var namedRoutes = <String, WidgetBuilder>{
  RouteName.splash: (context) => const SplashScreen(),
  RouteName.home: (context) => const MainScreen(),
  RouteName.login: (context) => const LoginScreen(),
  RouteName.signUp: (context) => const SignUpScreen(),
  RouteName.search: (context) => const SearchScreen(),
};
