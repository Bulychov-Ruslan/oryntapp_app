import 'package:flutter/material.dart';  // Flutter-дың негізгі пакеті
import 'package:oryntapp/language/language_constants.dart';  // Тілдік константтарды пайдалану үшін қажет
import 'package:oryntapp/screens/map_parking_screen.dart';  // Тұрақ картасы экранын импорттау
import 'package:oryntapp/screens/search_parking_screen.dart';  // Тұрақ іздеу экранын импорттау
import 'package:oryntapp/screens/account_screen.dart';  // Аккаунт экранын импорттау

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  int _selectedIndex = 0; // Таңдалған элементтің индексі

  final List<Widget> _widgetOptions = [
    const MapParkingScreen(), // Тұрақ картасы беті
    const SearchParkingScreen(), // Тұрақ іздеу беті
    const AccountScreen(), // Аккаунт беті
  ];

  void _onItemTapped(int index) {
    // Төменгі навигациядағы элементті басқанда орындалатын функция
    setState(() {
      _selectedIndex = index; // Таңдалған элементтің индексін жаңарту
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Таңдалған элементтің бетін көрсету
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Навигацияның түрін белгілеу
        backgroundColor: Colors.white.withOpacity(0.8), // Навигацияның фон түсін белгілеу
        selectedItemColor: Colors.black, // Таңдалған элементтің түсін белгілеу
        unselectedItemColor: Colors.grey.shade600, // Таңдалмаған элементтің түсін белгілеу
        iconSize: 33, // Иконкалардың өлшемі
        selectedFontSize: 16, // Таңдалған элементтің шрифт өлшемі
        unselectedFontSize: 14, // Таңдалмаған элементтің шрифт өлшемі
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.place), // Автотұрақ картасы иконкасы
            label: translation(context).parkings, // Автотұрақ картасы тексті
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search), // Іздеу иконкасы
            label: translation(context).search, // Іздеу тексті
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person), // Профиль иконкасы
            label: translation(context).profile, // Профиль тексті
          ),
        ],
        currentIndex: _selectedIndex, // Таңдалған элементтің индексі
        onTap: _onItemTapped, // Таңдалған элементті басқанда орындалатын функция
      ),
    );
  }
}
