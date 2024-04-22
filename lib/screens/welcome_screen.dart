import 'package:flutter/material.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        body: Column(
          children: [

            const SizedBox(height: 50),

            const SizedBox(height: 100),

            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset("assets/images/welcome_photo.png"),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Parking",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 2,
              ),
            ),

            const Text(
              "parking park your car",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Material(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text("Log In", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),

                Material(
                  color: Colors.indigoAccent,
                  borderRadius: BorderRadius.circular(15),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )

              ],
            ),
          ],
        ));
  }
}
