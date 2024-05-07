import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:oryntapp/language/language_constants.dart';

class SearchParkingScreen extends StatefulWidget {
  const SearchParkingScreen({super.key});

  @override
  _SearchParkingScreenState createState() => _SearchParkingScreenState();
}

class _SearchParkingScreenState extends State<SearchParkingScreen> {
  late List<Map<String, dynamic>> originalParkingList;
  List<Map<String, dynamic>> parkingList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchParkingList();
  }

  Future<void> fetchParkingList() async {
    try {
      // var url = 'http://10.0.2.2:5000/parkings'; // Для Эмулятора
      // var url = 'http://192.168.68.137:5000/parkings/'; // Для Мобильного устройства с мобильным интернетом
      var url = 'http://192.168.0.12:5000/parkings'; // Для Мобильного устройства с Wi-Fi Batys_5G
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          originalParkingList = data
              .map((parking) =>
                  {'id': parking['id'], 'address': parking['address']})
              .toList();
          parkingList = List.from(originalParkingList);
        });
      } else {
        throw Exception('Failed to load parking list');
      }
    } catch (e) {
      print('Error fetching parking list: $e');
    }
  }

  void searchParking(String searchTerm) {
    List<Map<String, dynamic>> searchResult = [];

    if (searchTerm.isEmpty) {
      setState(() {
        parkingList = List.from(originalParkingList);
      });
    } else {
      searchResult.addAll(originalParkingList.where(
          (parking) => parking['address'].toLowerCase().contains(searchTerm)));
      setState(() {
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: searchParking,
              decoration: InputDecoration(
                labelText: translation(context).searchByAddress,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
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
                            vertical: 5, horizontal: 10),
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
