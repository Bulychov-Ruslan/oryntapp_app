import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:oryntapp/screens/welcome_screen.dart';

import 'package:oryntapp/screens/login_screen.dart';
import 'package:oryntapp/screens/reset_password_screen.dart';
import 'package:oryntapp/screens/signup_screen.dart';
import 'package:oryntapp/screens/verify_email_screen.dart';

import 'package:oryntapp/screens/home_screen.dart';
import 'package:oryntapp/screens/map_screen.dart';
import 'package:oryntapp/screens/favorites_screen.dart';
import 'package:oryntapp/screens/account_screen.dart';

import 'package:oryntapp/services/firebase_streem.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/favorites': (context) => const FavoritesScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/'
    );
  }
}
