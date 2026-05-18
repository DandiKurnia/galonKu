// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get greeting => 'Selamat Datang';

  @override
  String get subSignIn => 'Masuk ke Galonku untuk melanjutkan';

  @override
  String get subSignUp => 'Lengkapi data diri Anda untuk membuat akun Galonku';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Daftar';

  @override
  String get noAccount => 'Tidak Punya Akun?';

  @override
  String get register => 'Daftar Sekarang';

  @override
  String get haveAccount => 'Punya Akun?';

  @override
  String get login => 'Masuk Sekarang';

  @override
  String get email => 'Email Address';

  @override
  String get password => 'Password';

  @override
  String get name => 'Nama Lengkap';
}
