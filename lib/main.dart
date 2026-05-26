import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galonku/l10n/app_localizations.dart';
import 'package:galonku/providers/auth_provider.dart';
import 'package:galonku/providers/map_notifier.dart';
import 'package:galonku/providers/search_notifier.dart';
import 'package:galonku/providers/stores_notifier.dart';
import 'package:galonku/providers/transaction_provider.dart';
import 'package:galonku/routes/app_route.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => StoresNotifier()),
            ChangeNotifierProvider(create: (_) => SearchNotifier()),
            ChangeNotifierProvider(create: (_) => MapNotifier()),
            ChangeNotifierProvider(create: (_) => TransactionProvider()),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', ''), Locale('id', '')],
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoute.onGenerateRoute,
            initialRoute: '/',
          ),
        );
      },
    );
  }
}
