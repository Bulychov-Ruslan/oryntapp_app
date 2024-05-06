import 'package:flutter/material.dart';
import 'package:oryntapp/language/language_constants.dart';
import 'package:oryntapp/screens/map_parking_screen.dart';
import 'package:oryntapp/screens/search_parking_screen.dart';
import 'package:oryntapp/screens/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    const MapParkingScreen(),
    const SearchParkingScreen(),
    const AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white.withOpacity(0.8),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade600,
        iconSize: 33,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.place),
            label: translation(context).parkings,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: translation(context).search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: translation(context).profile,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
