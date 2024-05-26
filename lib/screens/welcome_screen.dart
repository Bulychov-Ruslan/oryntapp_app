import 'package:flutter/material.dart'; // Материал пакетін импорттау

import 'package:oryntapp/language/language_constants.dart'; // Тілді ауыстыру үшін импорттау
import 'package:oryntapp/language/language.dart'; // Тілді ауыстыру үшін импорттау

import '../main.dart'; // Main.dart файлын импорттау

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          // Тілді ауыстыру (Change Language)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<Language>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.language,
              ),
              onChanged: (Language? language) async {
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
                  )
                  .toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Сәлемдеcу тексті (Welcome Text)
                Text(
                  translation(context).welcome,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Сәлемдесі бетінің суреті
                Image.asset("assets/images/welcome_photo.png",
                    width: MediaQuery.of(context).size.width * 0.8),
                const SizedBox(height: 20),
                // Сәлемдесу бетінің мәтіні
                Text(
                  translation(context).welcomeText1,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Сәлемдесу бетінің екінші мәтіні
                Text(
                  translation(context).welcomeText2,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black45,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Кіру және тіркелу түймелері (Login and Signup Buttons)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Кіру түймесі (Login Button)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text(translation(context).login,
                          style: const TextStyle(color: Colors.white)),
                    ),
                    // Тіркелу түймесі (Signup Button)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text(translation(context).signup,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
