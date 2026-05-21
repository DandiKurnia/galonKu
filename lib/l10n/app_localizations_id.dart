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

  @override
  String get dashboardGreeting => 'Halo';

  @override
  String get dashboardSub => 'Mau isi galon hari ini?';

  @override
  String get headlineOne => 'Isi Galon';

  @override
  String get headlineTwo => 'Mudah & Praktis';

  @override
  String get subHeadline =>
      'Temukan sendiri dispenser air minum terdekat dan isi galon Anda.';

  @override
  String get checkOut => 'Pesan Sekarang';

  @override
  String get tutorial => 'Cara Penggunaan';

  @override
  String get pickLocation => 'Pilih Lokasi';

  @override
  String get pickMesin => 'Pilih Mesin';

  @override
  String get payment => 'Pembayaran';

  @override
  String get fillUp => 'Isi Galon';

  @override
  String get scanCode => 'Scan QR Code';

  @override
  String get location => 'Lokasi Terdekat';

  @override
  String get findAll => 'Lihat Semua';

  @override
  String get tileAppbar => 'Pilih Lokasi';

  @override
  String get searchLocation => 'Cari Lokasi terdekat ...';

  @override
  String get transactionAppbar => 'Riwayat Transaksi';

  @override
  String get transactionTitle => 'Air Galon (19L)';

  @override
  String get filterAll => 'Semua';

  @override
  String transactionAmount(String count, String machine) {
    return '$count Galon | Mesin $machine';
  }

  @override
  String get statusTransaction => 'Selesai';

  @override
  String get cancelTransaction => 'Dibatalkan';

  @override
  String get showDetail => 'Lihat Detail';

  @override
  String get profileAppbar => 'Profil';

  @override
  String get profileAccount => 'Akun';

  @override
  String get profileGeneral => 'Umum';

  @override
  String get editProfile => 'Edit Profil';

  @override
  String get help => 'Bantuan';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get rateApp => 'Beri Rating Aplikasi';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirmTitle => 'Keluar dari Akun?';

  @override
  String get logoutConfirmMessage => 'Anda akan keluar dari akun Galonku.';

  @override
  String get cancel => 'Batal';

  @override
  String get editProfileTitle => 'Edit Profil';

  @override
  String get editProfileSub => 'Perbarui informasi akun Anda';

  @override
  String get phoneNumber => 'Nomor Telepon';

  @override
  String get address => 'Alamat';

  @override
  String get save => 'Simpan';

  @override
  String get changePhoto => 'Ubah Foto';

  @override
  String get saveSuccess => 'Profil berhasil diperbarui';
}
