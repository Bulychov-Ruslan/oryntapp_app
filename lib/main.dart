import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:oryntapp/screens/welcome_screen.dart';

import 'package:oryntapp/screens/login_screen.dart';
import 'package:oryntapp/screens/reset_password_screen.dart';
import 'package:oryntapp/screens/signup_screen.dart';
import 'package:oryntapp/screens/verify_email_screen.dart';

import 'package:oryntapp/screens/home_screen.dart';
import 'package:oryntapp/screens/map_parking_screen.dart';
import 'package:oryntapp/screens/search_parking_screen.dart';
import 'package:oryntapp/screens/account_screen.dart';

import 'package:oryntapp/screens/parking.dart';

import 'package:oryntapp/services/firebase_streem.dart';

import 'firebase_options.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:oryntapp/language/language_constants.dart';

// Орталық қосымша
Future<void> main() async {
  // Firebase инициализациясы
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  // Жаңа локальді орнату үшін
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  // Жаңа локаль
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => setLocale(locale));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      // Жаңа экрандарды қосу
      routes: {
        '/': (context) => const FirebaseStream(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapParkingScreen(),
        '/favorites': (context) => const SearchParkingScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),

        '/parking': (context) => const ParkingScreen(),
      },
      // Бастапқы экран
      initialRoute: '/',
    );
  }
}
