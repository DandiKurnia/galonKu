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

  @override
  String get dashboardGreeting => 'Hello';

  @override
  String get dashboardSub => 'Want to fill your gallon today?';

  @override
  String get headlineOne => 'Fill Gallon';

  @override
  String get headlineTwo => 'Easy & Practical';

  @override
  String get subHeadline =>
      'Find yourself the nearest water dispenser and fill your gallon.';

  @override
  String get checkOut => 'Check Out';

  @override
  String get tutorial => 'How to Use';

  @override
  String get pickLocation => 'Pick Location';

  @override
  String get pickMesin => 'Pick Machine';

  @override
  String get payment => 'Payment';

  @override
  String get fillUp => 'Fill Up';

  @override
  String get scanCode => 'Scan QR Code';

  @override
  String get location => 'Location';

  @override
  String get findAll => 'Find All';

  @override
  String get tileAppbar => 'Location';

  @override
  String get searchLocation => 'Search for the nearest location ...';

  @override
  String get transactionAppbar => 'Transaction History';

  @override
  String get transactionTitle => 'Gallon Water (19L)';

  @override
  String get filterAll => 'All';

  @override
  String transactionAmount(String count, String machine) {
    return '$count Gallons | Machine $machine';
  }

  @override
  String get statusTransaction => 'Completed';

  @override
  String get cancelTransaction => 'Cancelled';

  @override
  String get showDetail => 'Show Detail';

  @override
  String get profileAppbar => 'Profile';

  @override
  String get profileAccount => 'Account';

  @override
  String get profileGeneral => 'General';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get help => 'Help';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get rateApp => 'Rate App';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout from Account?';

  @override
  String get logoutConfirmMessage =>
      'You will be signed out of your Galonku account.';

  @override
  String get cancel => 'Cancel';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileSub => 'Update your account information';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get save => 'Save';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get saveSuccess => 'Profile updated successfully';

  @override
  String get checkoutAppbar => 'Checkout';

  @override
  String get water => 'Water';

  @override
  String get subTextGalon => 'Gallon Water (19L)';

  @override
  String get countGallon => 'Gallon Count';

  @override
  String get locationName => 'Location';

  @override
  String get machine => 'Machine';

  @override
  String get count => 'Count';

  @override
  String get total => 'Total';

  @override
  String get chooseGallon => 'Choose Gallon';

  @override
  String get quantity => 'Quantity';

  @override
  String get fillLocation => 'Fill Location';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get pay => 'Pay';

  @override
  String get balance => 'Balance';

  @override
  String get checkoutSuccess => 'Purchase successful! Processing water...';
}
