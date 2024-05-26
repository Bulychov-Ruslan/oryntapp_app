import 'package:email_validator/email_validator.dart';  // Электрондық поштаның дұрыстығын тексеру үшін қажет
import 'package:firebase_auth/firebase_auth.dart';  // Firebase аутентификациясы үшін қажет
import 'package:flutter/material.dart';  // Flutter-дың негізгі пакеті
import 'package:oryntapp/services/snack_bar.dart';  // SnackBar қызметін пайдалану үшін қажет
import 'package:oryntapp/language/language_constants.dart';  // Тілдік константтарды пайдалану үшін қажет


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailTextInputController = TextEditingController(); // Электрондық пошта енгізу өрісі үшін контроллер
  final formKey = GlobalKey<FormState>(); // Форма күйін бақылау үшін кілт

  @override
  void dispose() {
    // Контроллерді тазалау
    emailTextInputController.dispose();

    super.dispose();
  }
  // Құпия сөзді қалпына келтіру функциясы.
  Future<void> resetPassword() async {
    final navigator = Navigator.of(context);
    final scaffoldMassager = ScaffoldMessenger.of(context);

    final isValid = formKey.currentState!.validate(); // Форма деректерін тексеру
    if (!isValid) return;

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextInputController.text.trim()); // Құпия сөзді қалпына келтіру хатын жіберу

    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'user-not-found') {
        SnackBarService.showSnackBar(
          context,
          translation(context).thisEmailIsNotRegistered,
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          translation(context).unknownErrorTryAgainOrContactSupport,
          true,
        );
        return;
      }
    }

    var snackBar = SnackBar(
      content: Text(translation(context).passwordResetEmailSent),
      backgroundColor: Colors.green,
    );

    scaffoldMassager.showSnackBar(snackBar);
    // Қалпына келтіру хаты жіберілгеннен кейін кіру экранына ауысу
    navigator.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translation(context).resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // Электрондық пошта енгізу өрісі
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailTextInputController,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? translation(context).enterCorrectEmail
                        : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  hintText: translation(context).enterEmail,
                ),
              ),

              const SizedBox(height: 30),
              // Құпия сөзді қалпына келтіру батырмасы
              ElevatedButton(
                onPressed: resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(translation(context).resetPassword,
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
