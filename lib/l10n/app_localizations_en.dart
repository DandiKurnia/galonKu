// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get greeting => 'Welcome';

  @override
  String get subSignIn => 'Sign in to Galonku to continue';

  @override
  String get subSignUp => 'Complete your profile to create a Galonku account';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get noAccount => 'Don\'t have Account?';

  @override
  String get register => 'Sign Up Now';

  @override
  String get haveAccount => 'Already have Account?';

  @override
  String get login => 'Sign In Now';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get name => 'Full Name';
}
