import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @greeting.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang'**
  String get greeting;

  /// No description provided for @subSignIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk ke Galonku untuk melanjutkan'**
  String get subSignIn;

  /// No description provided for @subSignUp.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi data diri Anda untuk membuat akun Galonku'**
  String get subSignUp;

  /// No description provided for @signIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get signUp;

  /// No description provided for @noAccount.
  ///
  /// In id, this message translates to:
  /// **'Tidak Punya Akun?'**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In id, this message translates to:
  /// **'Daftar Sekarang'**
  String get register;

  /// No description provided for @haveAccount.
  ///
  /// In id, this message translates to:
  /// **'Punya Akun?'**
  String get haveAccount;

  /// No description provided for @login.
  ///
  /// In id, this message translates to:
  /// **'Masuk Sekarang'**
  String get login;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In id, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get name;

  /// No description provided for @dashboardGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo'**
  String get dashboardGreeting;

  /// No description provided for @dashboardSub.
  ///
  /// In id, this message translates to:
  /// **'Mau isi galon hari ini?'**
  String get dashboardSub;

  /// No description provided for @headlineOne.
  ///
  /// In id, this message translates to:
  /// **'Isi Galon'**
  String get headlineOne;

  /// No description provided for @headlineTwo.
  ///
  /// In id, this message translates to:
  /// **'Mudah & Praktis'**
  String get headlineTwo;

  /// No description provided for @subHeadline.
  ///
  /// In id, this message translates to:
  /// **'Temukan sendiri dispenser air minum terdekat dan isi galon Anda.'**
  String get subHeadline;

  /// No description provided for @checkOut.
  ///
  /// In id, this message translates to:
  /// **'Pesan Sekarang'**
  String get checkOut;

  /// No description provided for @tutorial.
  ///
  /// In id, this message translates to:
  /// **'Cara Penggunaan'**
  String get tutorial;

  /// No description provided for @pickLocation.
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get pickLocation;

  /// No description provided for @pickMesin.
  ///
  /// In id, this message translates to:
  /// **'Pilih Mesin'**
  String get pickMesin;

  /// No description provided for @payment.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get payment;

  /// No description provided for @fillUp.
  ///
  /// In id, this message translates to:
  /// **'Isi Galon'**
  String get fillUp;

  /// No description provided for @scanCode.
  ///
  /// In id, this message translates to:
  /// **'Scan QR Code'**
  String get scanCode;

  /// No description provided for @location.
  ///
  /// In id, this message translates to:
  /// **'Lokasi Terdekat'**
  String get location;

  /// No description provided for @findAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get findAll;

  /// No description provided for @tileAppbar.
  ///
  /// In id, this message translates to:
  /// **'Pilih Lokasi'**
  String get tileAppbar;

  /// No description provided for @searchLocation.
  ///
  /// In id, this message translates to:
  /// **'Cari Lokasi terdekat ...'**
  String get searchLocation;

  /// No description provided for @transactionAppbar.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Transaksi'**
  String get transactionAppbar;

  /// No description provided for @transactionTitle.
  ///
  /// In id, this message translates to:
  /// **'Air Galon (19L)'**
  String get transactionTitle;

  /// No description provided for @filterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get filterAll;

  /// No description provided for @transactionAmount.
  ///
  /// In id, this message translates to:
  /// **'{count} Galon | Mesin {machine}'**
  String transactionAmount(String count, String machine);

  /// No description provided for @statusTransaction.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get statusTransaction;

  /// No description provided for @cancelTransaction.
  ///
  /// In id, this message translates to:
  /// **'Dibatalkan'**
  String get cancelTransaction;

  /// No description provided for @showDetail.
  ///
  /// In id, this message translates to:
  /// **'Lihat Detail'**
  String get showDetail;

  /// No description provided for @transactionStatusPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get transactionStatusPending;

  /// No description provided for @transactionStatusPaid.
  ///
  /// In id, this message translates to:
  /// **'Dibayar'**
  String get transactionStatusPaid;

  /// No description provided for @transactionStatusExpired.
  ///
  /// In id, this message translates to:
  /// **'Kedaluwarsa'**
  String get transactionStatusExpired;

  /// No description provided for @transactionStatusFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get transactionStatusFailed;

  /// No description provided for @transactionEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi'**
  String get transactionEmpty;

  /// No description provided for @profileAppbar.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileAppbar;

  /// No description provided for @profileAccount.
  ///
  /// In id, this message translates to:
  /// **'Akun'**
  String get profileAccount;

  /// No description provided for @profileGeneral.
  ///
  /// In id, this message translates to:
  /// **'Umum'**
  String get profileGeneral;

  /// No description provided for @editProfile.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfile;

  /// No description provided for @help.
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get help;

  /// No description provided for @privacyPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kebijakan Privasi'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In id, this message translates to:
  /// **'Ketentuan Layanan'**
  String get termsOfService;

  /// No description provided for @rateApp.
  ///
  /// In id, this message translates to:
  /// **'Beri Rating Aplikasi'**
  String get rateApp;

  /// No description provided for @logout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Akun?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In id, this message translates to:
  /// **'Anda akan keluar dari akun Galonku.'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @editProfileTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get editProfileTitle;

  /// No description provided for @editProfileSub.
  ///
  /// In id, this message translates to:
  /// **'Perbarui informasi akun Anda'**
  String get editProfileSub;

  /// No description provided for @phoneNumber.
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get address;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @changePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ubah Foto'**
  String get changePhoto;

  /// No description provided for @saveSuccess.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui'**
  String get saveSuccess;

  /// No description provided for @checkoutAppbar.
  ///
  /// In id, this message translates to:
  /// **'Checkout'**
  String get checkoutAppbar;

  /// No description provided for @water.
  ///
  /// In id, this message translates to:
  /// **'Air Minum'**
  String get water;

  /// No description provided for @subTextGalon.
  ///
  /// In id, this message translates to:
  /// **'Air Galon (19L)'**
  String get subTextGalon;

  /// No description provided for @countGallon.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Galon'**
  String get countGallon;

  /// No description provided for @locationName.
  ///
  /// In id, this message translates to:
  /// **'Lokasi'**
  String get locationName;

  /// No description provided for @machine.
  ///
  /// In id, this message translates to:
  /// **'Mesin'**
  String get machine;

  /// No description provided for @count.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get count;

  /// No description provided for @total.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @chooseGallon.
  ///
  /// In id, this message translates to:
  /// **'Pilih Galon'**
  String get chooseGallon;

  /// No description provided for @quantity.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get quantity;

  /// No description provided for @fillLocation.
  ///
  /// In id, this message translates to:
  /// **'Tujuan Pengisian'**
  String get fillLocation;

  /// No description provided for @paymentMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode Pembayaran'**
  String get paymentMethod;

  /// No description provided for @subtotal.
  ///
  /// In id, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @pay.
  ///
  /// In id, this message translates to:
  /// **'Bayar'**
  String get pay;

  /// No description provided for @balance.
  ///
  /// In id, this message translates to:
  /// **'Saldo'**
  String get balance;

  /// No description provided for @checkoutSuccess.
  ///
  /// In id, this message translates to:
  /// **'Pembelian berhasil! Memproses air...'**
  String get checkoutSuccess;

  /// No description provided for @allStoresAppbar.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get allStoresAppbar;

  /// No description provided for @storeOpen.
  ///
  /// In id, this message translates to:
  /// **'Buka'**
  String get storeOpen;

  /// No description provided for @storeClosed.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get storeClosed;

  /// No description provided for @storeMachineCount.
  ///
  /// In id, this message translates to:
  /// **'{active}/{total} mesin'**
  String storeMachineCount(String active, String total);

  /// No description provided for @storeEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada toko tersedia'**
  String get storeEmpty;

  /// No description provided for @tryAgain.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get tryAgain;

  /// No description provided for @detailStoreAppbar.
  ///
  /// In id, this message translates to:
  /// **'Detail Toko'**
  String get detailStoreAppbar;

  /// No description provided for @detailStoreInvalidId.
  ///
  /// In id, this message translates to:
  /// **'ID toko tidak valid'**
  String get detailStoreInvalidId;

  /// No description provided for @detailStoreMachineSection.
  ///
  /// In id, this message translates to:
  /// **'Mesin ({active}/{total} aktif)'**
  String detailStoreMachineSection(String active, String total);

  /// No description provided for @detailStoreNoMachine.
  ///
  /// In id, this message translates to:
  /// **'Belum ada mesin'**
  String get detailStoreNoMachine;

  /// No description provided for @machineActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get machineActive;

  /// No description provided for @machineInactive.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get machineInactive;

  /// No description provided for @openInMaps.
  ///
  /// In id, this message translates to:
  /// **'Buka di Google Maps'**
  String get openInMaps;

  /// No description provided for @openMapsFailed.
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa membuka Google Maps'**
  String get openMapsFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
