import 'package:email_validator/email_validator.dart';  // Электрондық поштаның дұрыстығын тексеру үшін қажет
import 'package:firebase_auth/firebase_auth.dart';  // Firebase аутентификациясы үшін қажет
import 'package:flutter/material.dart';  // Flutter-дың негізгі пакеті
import 'package:lottie/lottie.dart';  // Lottie анимацияларын пайдалану үшін пакет

import 'package:oryntapp/main.dart';  // Негізгі қолданба файлын импорттау
import 'package:oryntapp/services/snack_bar.dart';  // SnackBar қызметін пайдалану үшін қажет

import 'package:oryntapp/language/language.dart';  // Тілдік параметрлерді пайдалану үшін қажет
import 'package:oryntapp/language/language_constants.dart';  // Тілдік константтарды пайдалану үшін қажет


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true; // Құпия сөзді көрсету/жасыру күйі
  TextEditingController emailTextInputController = TextEditingController(); // Электрондық пошта енгізу өрісі үшін контроллер
  TextEditingController passwordTextInputController = TextEditingController(); // Құпия сөзді енгізу өрісі үшін контроллер
  final formKey = GlobalKey<FormState>(); // Форма күйін бақылау үшін кілт


  @override
  void dispose() {
    // Контроллерлерді тазалау
    emailTextInputController.dispose();
    passwordTextInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    // Құпия сөзді көрсету/жасыру күйін өзгерту
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
  // Кіру функциясы.
  Future<void> login() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate(); // Форма деректерін тексеру
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      // Сәтті кіргеннен кейін анимация көрсету
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/success_animation.json',
                    width: 150,
                    height: 150,
                    repeat: false,
                    onLoaded: (composition) {
                      Future.delayed(composition.duration).then((_) {
                        Navigator.of(context).pop();
                        navigator.pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                      });
                    }),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    translation(context).successfulAuthorization,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          translation(context).inCorrectEmailOrPasswordTryAgain,
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translation(context).login),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
              ),
              onChanged: (Language? language) async {
                // Тілді өзгерту
                if (language != null) {
                  Locale _locale = await setLocale(language.languageCode);
                  MyApp.setLocale(context, _locale);
                }
              },

              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                  value: e,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        e.flag,
                        style: const TextStyle(fontSize: 30),
                      ),
                      Text(e.name)
                    ],
                  ),
                ),
              ).toList(),
            ),

          ),
        ],
      ),


      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Қолданбаның атауы
              Text(
                'OrynTapp',
                style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 50),
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

              const SizedBox(height: 10),
              // Құпия сөзді енгізу өрісі
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                validator: (value) => value != null && value.length < 6
                    ? translation(context).minimum6Characters
                    : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: translation(context).password,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: translation(context).enterPassword,
                  suffixIcon: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Кіру батырмасы
              ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  translation(context).login,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              // Құпия сөзді қалпына келтіру батырмасы
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('/reset_password'),
                child: Text(
                  translation(context).resetPassword,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                  ),
                ),
              ),
              Spacer(),
              // Егер тіркелмеген болсаңыз, тіркелу батырмасы
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(translation(context).dontHaveAnAccount,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/signup'),
                    child: Text(
                      translation(context).signup,
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

