import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:oryntapp/language/language_constants.dart';

// Автотұрақтар орындарын фильтрлеу түрлері
enum FilterType { all, free, occupied }

// Автотұрақ экраны
class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  // Автотұрақ орындарының күйі
  List<List<bool>> parkingStatus = [];
  // Автотұрақ мекен-жайы
  String parkingAddress = '';
  // Таймер
  Timer? _timer;
  // Ағымдағы автотұрақ ID
  String? currentParkingId;
  // Бос орындар саны
  int freeSpaces = 0;
  // Бос емес орындар саны
  int occupiedSpaces = 0;
  // Фильтр түрі
  FilterType filterType = FilterType.all;

  @override
  void initState() {
    super.initState();
    // Автотұрақ ID-сін алу
    Future.delayed(Duration.zero, () {
      currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
      // Автотұрақ деректерін алу
      fetchParkingData(currentParkingId!);
      // Таймерді іске қосу
      _timer = Timer.periodic(Duration(seconds: 1),
              (Timer t) => fetchParkingData(currentParkingId!));
    });
  }
  // Автотұрақ деректерін алу функциясы
  Future<void> fetchParkingData(String parkingId) async {
    // var url = 'http://10.0.2.2:5000/parkings/$parkingId';
    var url = 'http://192.168.1.137:5000/parkings/$parkingId';
    // var url = 'http://192.168.0.12:5000/parkings/$parkingId';
    // var url = 'http://10.68.7.125:5000/parkings/$parkingId';
    // Серверге HTTP запрос жасау
    final response = await http.get(Uri.parse(url));
    // Серверден деректерді алу
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        List<dynamic> rows = data['status'] as List<dynamic>;
        // Автотұрақ орындарының күйін жаңарту
        parkingStatus =
            rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
        // Автотұрақ мекен-жайын жаңарту
        parkingAddress = data['address'] as String;

        // Бос және бос емес орындарды санау
        freeSpaces = 0;
        occupiedSpaces = 0;

        // Автотұрақ орындарын санау
        for (int i = 0; i < parkingStatus.length; i++) {
          for (int j = 0; j < parkingStatus[i].length; j++) {
            if (parkingStatus[i][j]) {
              occupiedSpaces++;
            } else {
              freeSpaces++;
            }
          }
        }
      });
    } else {
      // Серверден деректерді алу мүмкін емес
      throw Exception('Failed to load parking data');
    }
  }

  @override
  // Таймерді жою
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(translation(context).parkingPlaces),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          // Автотұрақ мекен-жайы
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
            child: Text(
              '${translation(context).address} $parkingAddress',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Бос және бос емес орындарды саны
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.local_parking),
                title: Text(translation(context).freeSeats),
                trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
            ),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(translation(context).occupiedPlaces),
                trailing: Text('$occupiedSpaces', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(translation(context).filter),
          // Фильтрлеу түрлері
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.all)
                          return Colors.blue;
                        return Colors.grey;
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.all;
                    });
                  },
                  child: Text(translation(context).allPlaces, style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.free)
                          return Colors.blue;
                        return Colors.grey;
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.free;
                    });
                  },
                  child: Text(translation(context).free, style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.occupied)
                          return Colors.blue;
                        return Colors.grey;
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.occupied;
                    });
                  },
                  child: Text(translation(context).occupied, style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),

          const SizedBox(height: 25),
          // Автотұрақ орындары
          Expanded(
            child: ListView(
              children: List.generate(
                parkingStatus.length,
                    (rowIndex) {
                  int previousItemsCount = 0;
                  for (int k = 0; k < rowIndex; k++) {
                    previousItemsCount += parkingStatus[k].length;
                  }

                  return Column(
                    children: [
                      Text('${translation(context).row} ${rowIndex + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            parkingStatus[rowIndex].length,
                                (index) {
                              if (filterType == FilterType.free && parkingStatus[rowIndex][index]) {
                                return Container();
                              } else if (filterType == FilterType.occupied && !parkingStatus[rowIndex][index]) {
                                return Container();
                              }
                              int flatIndex = previousItemsCount + index + 1; // Нумерация начинается с 1
                              return Card(
                                child: Container(
                                  width: 70,
                                  height: 130,
                                  margin: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: parkingStatus[rowIndex][index]
                                        ? Colors.red
                                        : Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      parkingStatus[rowIndex][index]
                                          ? Icon(Icons.directions_car, color: Colors.white, size: 50.0)
                                          : Icon(Icons.local_parking, color: Colors.white, size: 50.0),

                                      const SizedBox(height: 20),

                                      Text(
                                        '$flatIndex',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,)
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // Фильтрлеу түрлерін ауыстыру үшін FloatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (filterType == FilterType.all) {
              filterType = FilterType.free;
            } else if (filterType == FilterType.free) {
              filterType = FilterType.occupied;
            } else {
              filterType = FilterType.all;
            }
          });
        },
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}




