import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oryntapp/screens/map_screen.dart';
import 'package:oryntapp/screens/favorites_screen.dart';
import 'package:oryntapp/screens/account_screen.dart';

import 'package:oryntapp/screens/login_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//
//     return Scaffold(
//
//       resizeToAvoidBottomInset: false,
//
//       appBar: AppBar(
//         title: const Text('Главная страница'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               if ((user == null)) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const LoginScreen()),
//                 );
//               } else {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AccountScreen()),
//                 );
//               }
//             },
//             icon: Icon(
//               Icons.person,
//               color: (user == null) ? Colors.black : Colors.yellow,
//             ),
//           ),
//         ],
//       ),
//
//       body: SafeArea(
//         child: Center(
//           child: (user == null)
//               ? const Text("Контент для НЕ зарегистрированных в системе")
//               : const Text('Контент для ЗАРЕГИСТРИРОВАННЫХ в системе'),
//           //child: Text('Контент для НЕ зарегистрированных в системе'),
//         ),
//       ),
//
//     );
//   }
// }
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = const [
    MapScreen(),
    FavoritesScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(


      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.indigo,
        // selectedItemColor: Colors.amber,
        // unselectedItemColor: Colors.white,
        iconSize: 33,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Parking',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


