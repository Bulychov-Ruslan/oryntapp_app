import 'package:cloud_firestore/cloud_firestore.dart';  // Firebase Firestore-мен жұмыс істеу үшін қажет
import 'package:email_validator/email_validator.dart';  // Email-дің дұрыстығын тексеру үшін қажет
import 'package:firebase_auth/firebase_auth.dart';  // Firebase аутентификациясы үшін қажет

import 'package:flutter/material.dart';  // Flutter-дың негізгі пакеті
import 'package:oryntapp/services/snack_bar.dart';  // Snackbar қызметін пайдалану үшін қажет

import 'package:oryntapp/language/language.dart';  // Тілдік параметрлерді пайдалану үшін қажет
import 'package:oryntapp/language/language_constants.dart';  // Тілдік константтарды пайдалану үшін қажет

import '../main.dart';  // Негізгі қолданба файлын импорттау

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool isHiddenPassword = true;  // Құпия сөзді көрсету/жасыру
  TextEditingController emailTextInputController = TextEditingController();  // Email енгізу өрісі үшін контроллер
  TextEditingController passwordTextInputController = TextEditingController();  // Құпия сөзді енгізу өрісі үшін контроллер
  TextEditingController passwordTextRepeatInputController = TextEditingController();  // Құпия сөзді қайта енгізу өрісі үшін контроллер
  final formKey = GlobalKey<FormState>();  // Форма күйін бақылау үшін кілт

  @override
  void dispose() {
    // Контроллерлерді тазалау
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    // Құпия сөзді көрсету/жасыру күйін өзгерту
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
  // Қолданушыны тіркеу функциясы.
  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate(); // Форма деректерін тексеру
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(
        context,
        translation(context).passwordsDoNotMatch,
        true,
      );
      return;
    }

    try {
      UserCredential userCredential=
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      // Жаңа қолданушыны Firestore-ға қосу
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username':emailTextInputController.text.trim().split('@')[0],
      });

    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          translation(context).emailAlreadyExists,
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          translation(context).unknownErrorTryAgainOrContactSupport,
          true,
        );
      }
    }
    // Тіркелгеннен кейін басты экранға ауысу
    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(translation(context).signup),
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
              // Email енгізу өрісі
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
              // Құпия сөз енгізу өрісі
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? translation(context).minimum6Characters
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: translation(context).password,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: translation(context).enterPassword,
                  suffix: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Құпия сөзді қайта енгізу өрісі
              TextFormField(
                autocorrect: false,
                controller: passwordTextRepeatInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? translation(context).minimum6Characters
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: translation(context).repeatPassword,
                  prefixIcon: const Icon(Icons.lock),
                  hintText: translation(context).enterRepeatPassword,
                  suffix: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Тіркелу батырмасы
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  translation(context).signup,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Spacer(),
              // Тіркелген жағдайда кіру батырмасы
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(translation(context).alreadyHaveAnAccount,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'),
                    child: Text(
                      translation(context).login,
                      style: const TextStyle(
                        color: Colors.green,
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
