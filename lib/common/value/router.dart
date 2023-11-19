import 'package:flutter/material.dart';
import 'package:sprit/screens/home_screen.dart';
import 'package:sprit/screens/login/login_screen.dart';
import 'package:sprit/screens/login/sign_up_screen.dart';
import 'package:sprit/screens/splash/splash_screen.dart';

class RouteName {
  static const splash = "/";
  static const home = "/home";
  static const login = "/login";
  static const signUp = "/signUp";
}

var namedRoutes = <String, WidgetBuilder>{
  RouteName.splash: (context) => const SplashScreen(),
  RouteName.home: (context) => const HomeScreen(),
  RouteName.login: (context) => const LoginScreen(),
  '/signUp': (context) => const SignUpScreen(),
};
