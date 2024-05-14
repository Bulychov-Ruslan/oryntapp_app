import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oryntapp/language/language_constants.dart';
import 'package:oryntapp/services/snack_bar.dart';

import 'login_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    print(isEmailVerified);

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));

      setState(() => canResendEmail = true);
    } catch (e) {
      print(e);
      if (mounted) {
        // SnackBarService.showSnackBar(
        //   context,
        //   '$e',
        //   true,
        // );
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? LoginScreen()
      : Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(translation(context).emailAddressVerification),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      translation(context).emailVerificationSent,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: canResendEmail ? sendVerificationEmail : null,
                      icon: const Icon(Icons.email),
                      label: Text(
                        translation(context).resendVerificationEmail,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                      ),

                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () async {
                        timer?.cancel();
                        await FirebaseAuth.instance.currentUser!.delete();
                      },
                      child: Text(
                        translation(context).cancel,
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );
}
