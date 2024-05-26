import 'dart:async';  // Асинхронды операциялар үшін Dart пакетінің импорты
import 'package:lottie/lottie.dart';  // Lottie анимацияларын пайдалану үшін пакет
import 'package:firebase_auth/firebase_auth.dart';  // Firebase аутентификациясы үшін пакет
import 'package:flutter/material.dart';  // Flutter-дің негізгі пакеті
import 'package:oryntapp/language/language_constants.dart';  // Тілдік константтарды импорттаймыз
import 'login_screen.dart';  // Кіру экранын импорттаймыз


class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false; // Электрондық поштаның расталғанын көрсететін белгі
  bool canResendEmail = false;  // Электрондық поштаны қайта жіберуге болатындығын көрсететін белгі
  Timer? timer; // Таймер объектісі

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified; // Қазіргі қолданушының электрондық поштасының расталғанын тексереміз
    if (!isEmailVerified) {
      sendVerificationEmail(); // Егер расталмаған болса, растау хат жібереміз

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(), // Электрондық поштаның расталғанын әр 3 секунд сайын тексереміз
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Таймерді тоқтатамыз
    super.dispose();
  }
  // Электрондық поштаның расталғанын тексеру функциясы.
  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    bool newEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (newEmailVerified != isEmailVerified) {
      setState(() {
        isEmailVerified = newEmailVerified;
      });

      if (isEmailVerified) {
        timer?.cancel();
        showSuccessAnimation();
      }
    }
  }
  //Электрондық поштаны растау хатын жіберу функциясы.
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
        print(e);
      }
    }
  }
  // Сәтті тіркелді анимациясын көрсету функциясы.
  void showSuccessAnimation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/lottie/success_animation.json',
              width: 150,
              height: 150,
              repeat: false,
              onLoaded: (composition) {
                Future.delayed(composition.duration).then((_) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                });
              },
            ),
            Text(translation(context).successfulVerification,
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  if (!isEmailVerified)
                    Column(
                      children: [
                        Text(
                          translation(context).emailVerificationSent,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Электрондық поштаны қайта жіберу үшін түйме
                        ElevatedButton.icon(
                          onPressed:
                              canResendEmail ? sendVerificationEmail : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.email),
                          label: Text(
                            translation(context).resendVerificationEmail,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Электрондық поштаны растауды болдырмай түймесі
                        TextButton(
                          onPressed: () async {
                            timer?.cancel();
                            await FirebaseAuth.instance.currentUser!.delete();
                          },
                          child: Text(translation(context).cancel,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 18,
                              )),
                        )
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      );
}
