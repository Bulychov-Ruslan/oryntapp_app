import 'package:flutter/material.dart'; // Материал дизайны
import 'package:http/http.dart' as http; // HTTP сұрауларын жасау үшін
import 'dart:async'; // Асинхронды операциялар үшін
import 'dart:convert'; // JSON мәліметтерін парс қылу үшін

import 'package:oryntapp/language/language_constants.dart'; // Тіл пакеті


class SearchParkingScreen extends StatefulWidget {
  const SearchParkingScreen({super.key});

  @override
  _SearchParkingScreenState createState() => _SearchParkingScreenState();
}

class _SearchParkingScreenState extends State<SearchParkingScreen> {
  late List<Map<String, dynamic>> originalParkingList; // Бастапқы тұрақ тізімі
  List<Map<String, dynamic>> parkingList = []; // Қазіргі тұрақ тізімі
  TextEditingController searchController = TextEditingController(); // Іздеу жолын басқарушысы

  @override
  void initState() {
    super.initState();
    fetchParkingList(); // Тұрақтар тізімін алу
  }

  // Серверден тұрақ тізімін алу функциясы
  Future<void> fetchParkingList() async {
    try {
      // var url = 'http://10.0.2.2:5000/parkings';
      var url = 'http://192.168.1.137:5000/parkings';
      // var url = 'http://192.168.0.12:5000/parkings';
      // var url = 'http://10.68.7.125:5000/parkings';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          // Тұрақтар тізімін бастапқы және ағымдағы тізімге жаңарту
          originalParkingList = data
              .map((parking) =>
                  {'id': parking['id'], 'address': parking['address']})
              .toList();
          parkingList = List.from(originalParkingList);
        });
      } else {
        // Серверден тұрақтар тізімін алу мүмкін емес
        throw Exception('Failed to load parking list');
      }
    } catch (e) {
      // Серверге қосылу мүмкін емес
      print('Error fetching parking list: $e');
    }
  }

  // Іздеу жолында мекен-жай бойынша іздеу
  void searchParking(String searchTerm) {
    // Іздеу нәтижесін сақтау үшін жаңарту
    List<Map<String, dynamic>> searchResult = [];

    if (searchTerm.isEmpty) {
      setState(() {
        // Іздеу өрісі бос болса, бастапқы тізімді қалпына келтіру
        parkingList = List.from(originalParkingList);
      });
    } else {
      // Мекен-жай бойынша іздеу
      searchResult.addAll(originalParkingList.where(
          (parking) => parking['address'].toLowerCase().contains(searchTerm)));
      setState(() {
        // Нәтижені жаңарту
        parkingList = searchResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).listParking),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            // Іздеу жолының интерфейсі
            child: TextField(
              controller: searchController,
              onChanged: searchParking,
              decoration: InputDecoration(
                labelText: translation(context).searchByAddress,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: parkingList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: parkingList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        // Тұрақ көрсетілген карточка
                        child: Card(
                          elevation: 2,
                          child: ListTile(
                            leading: const Icon(Icons.local_parking,
                                size: 48, color: Colors.blue),
                            title: Text(
                              '${translation(context).parkingId} ${parkingList[index]['id']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${translation(context).address} ${parkingList[index]['address']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            // Тұраққа орындары бетіне өту
                            onTap: () {
                              final parkingId = parkingList[index]['id'];
                              Navigator.of(context)
                                  .pushNamed('/parking', arguments: parkingId);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
