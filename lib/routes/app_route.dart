import 'package:flutter/material.dart';
import 'package:galonku/pages/sign_in_page.dart';
import 'package:galonku/pages/splash_page.dart';

class AppRoute {
  static Map<String, WidgetBuilder> get routes => {
    '/': (context) => const SplashPage(),
    '/sign-in': (context) => const SignInPage(),
  };
}
