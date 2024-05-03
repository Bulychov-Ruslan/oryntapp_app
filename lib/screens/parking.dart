import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<bool> parkingStatus = [];
  String parkingAddress = '';
  Timer? _timer;
  String? currentParkingId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
      fetchParkingData(currentParkingId!);
      _timer = Timer.periodic(Duration(seconds: 1),
          (Timer t) => fetchParkingData(currentParkingId!));
    });
  }

  Future<void> fetchParkingData(String parkingId) async {
    try {
      // var url = 'http://10.0.2.2:5000/parkings/$parkingId'; // Для Эмулятора
      // var url = 'http://192.168.68.137:5000/parkings/$parkingId'; // Для Мобильного устройства с мобильным интернетом
      var url = 'http://192.168.0.16:5000/parkings/$parkingId'; // Для Мобильного устройства с Wi-Fi Batys_5G
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          parkingStatus = List<bool>.from(data['status'] as List);
          parkingAddress = data['address'] as String;
        });
      } else {
        throw Exception('Failed to load parking data');
      }
    } catch (e) {
      print('Error fetching parking data: $e');
      // В реальном приложении здесь могло бы быть уведомление пользователя
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios, // add custom icons also
          ),
        ),
        title: Text('Парковочные места'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Адрес: $parkingAddress', // Виджет для отображения адреса
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: parkingStatus.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: parkingStatus[index] ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Место ${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
