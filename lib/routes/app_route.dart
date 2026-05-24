import 'package:flutter/material.dart';
import 'package:galonku/pages/edit_profile_page.dart';
import 'package:galonku/pages/sign_in_page.dart';
import 'package:galonku/pages/splash_page.dart';
import 'package:galonku/pages/sign_up_page.dart';
import 'package:galonku/pages/home/main_page.dart';
import 'package:galonku/pages/checkout_page.dart';

class AppRoute {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/':
        page = const SplashPage();
        break;
      case '/sign-in':
        page = const SignInPage();
        break;
      case '/sign-up':
        page = const SignUpPage();
        break;
      case '/main':
        page = const MainPage();
        break;
      case '/edit-profile':
        page = const EditProfilePage();
        break;
      case '/checkout':
        page = const CheckoutPage();
        break;
      default:
        return null;
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
