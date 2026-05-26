import 'package:flutter/material.dart';
import 'package:galonku/pages/all_stores_page.dart';
import 'package:galonku/pages/detail_store_page.dart';
import 'package:galonku/pages/edit_profile_page.dart';
import 'package:galonku/pages/payment_invoice_page.dart';
import 'package:galonku/pages/sign_in_page.dart';
import 'package:galonku/pages/splash_page.dart';
import 'package:galonku/pages/sign_up_page.dart';
import 'package:galonku/pages/home/main_page.dart';
import 'package:galonku/pages/checkout_page.dart';
import 'package:galonku/pages/transaction_detail_page.dart';

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
      case '/detail-store':
        page = const DetailStorePage();
        break;
      case '/all-stores':
        page = const AllStoresPage();
        break;
      case '/transaction-detail':
        page = const TransactionDetailPage();
        break;
      case '/payment-invoice':
        page = const PaymentInvoicePage();
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
