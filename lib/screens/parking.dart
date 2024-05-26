import 'package:flutter/material.dart'; // Flutter-дың негізгі пакеті
import 'package:http/http.dart' as http; // HTTP сұрауларды жіберу үшін қажет
import 'dart:async'; // Асинхронды операциялар үшін қажет
import 'dart:convert';  // JSON деректерін өңдеу үшін қажет

import 'package:oryntapp/language/language_constants.dart'; // Тілді ауыстыру үшін қажет

// Фильтр түрлері
enum FilterType { all, free, occupied }

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<List<bool>> parkingStatus = []; // Тұрақ орындарының статусын сақтау үшін тізім
  Map<int, int> reservations = {}; // Брондалған орындалды сақтауға
  String parkingAddress = ''; // Тұрақтың мекенжайы
  Timer? _timer; // Таймер объектісі
  String? currentParkingId; // Ағымдағы тұрақтың ID-ы
  int freeSpaces = 0; // Бос орындар саны
  int occupiedSpaces = 0; // Бос емес орындар саны
  FilterType filterType = FilterType.all; // Таңдалған фильтр түрі

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
      fetchParkingData(currentParkingId!);
      // Тұрақ деректерін әрбір секунд сайын жаңарту үшін таймер орнату
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchParkingData(currentParkingId!));
    });
  }
  // Тұрақ деректерін алу функциясы
  Future<void> fetchParkingData(String parkingId) async {
    var url = 'http://192.168.1.137:5000/parkings/$parkingId'; // Тұрақ деректерін алу үшін URL
    final response = await http.get(Uri.parse(url)); // HTTP GET сұрауын жіберу
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        List<dynamic> rows = data['status'] as List<dynamic>;
        parkingStatus = rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
        parkingAddress = data['address'] as String;

        freeSpaces = 0;
        occupiedSpaces = 0;
        // Тұрақ орындарының статусын санау
        for (int i = 0; i < parkingStatus.length; i++) {
          for (int j = 0; j < parkingStatus[i].length; j++) {
            if (parkingStatus[i][j]) {
              occupiedSpaces++;
            } else {
              freeSpaces++;
            }
          }
        }
        // Брондалған орындарды сақтау
        reservations.clear();
        if (data['reservations'] != null) {
          data['reservations'].forEach((index, expirationTime) {
            reservations[int.parse(index)] = expirationTime is int ? expirationTime : expirationTime.toInt();
            freeSpaces--;
            occupiedSpaces++;
          });
        }
      });
    } else {
      throw Exception('Failed to load parking data');
    }
  }
  // Орынды брондау функциясы
  Future<void> reserveParkingSpot(int rowIndex, int colIndex) async {
    int flatIndex = _getFlatIndex(rowIndex, colIndex);
    Duration? duration = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // Брондау уақытын таңдау диалогы
        return SimpleDialog(
          title: Text(translation(context).selectReservationDuration),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 5));
              },
              child: Text('5 ${translation(context).minutes}', style: const TextStyle(fontSize: 18, color: Colors.blue)),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 10));
              },
              child: Text('10 ${translation(context).minutes}', style: const TextStyle(fontSize: 18, color: Colors.blue)),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 20));
              },
              child: Text('20 ${translation(context).minutes}', style: const TextStyle(fontSize: 18, color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (duration != null) {
      var url = 'http://192.168.1.137:5000/reserve'; // Орынды брондау үшін URL
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'parkingId': currentParkingId,
          'spotIndex': flatIndex,
          'duration': duration.inSeconds,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          parkingStatus[rowIndex][colIndex] = true;
          occupiedSpaces++;
          freeSpaces--;
        });
        fetchParkingData(currentParkingId!); // Брондаудан кейін тұрақ деректерін жаңарту
      } else {
        // Handle reservation error
        print('Failed to reserve parking spot');
      }
    }
  }
  // Брондауды болдырмау функциясы
  Future<void> cancelReservation(int flatIndex) async {
    var url = 'http://192.168.1.137:5000/cancel_reservation'; // Брондауды болдырмау үшін URL
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'parkingId': currentParkingId,
        'spotIndex': flatIndex,
      }),
    );

    if (response.statusCode == 200) {
      fetchParkingData(currentParkingId!); // Брондаудан болдырмағаннан кейін тұрақ деректерін жаңарту
    } else {
      print('Failed to cancel reservation');
    }
  }

  // Брондауды болдырмау диалогын көрсету функциясы
  Future<void> _showCancelDialog(int flatIndex) async {
    bool confirmCancel = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // Брондауды болдырмауды растау диалогы
        return AlertDialog(
          title: Text(translation(context).confirmCancellation),
          content: Text(translation(context).areYouSureYouWantToCancelTheReservation, style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(translation(context).no),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(translation(context).yes),
            ),
          ],
        );
      },
    );

    if (confirmCancel) {
      cancelReservation(flatIndex); // Брондауды болдырмау
    }
  }
  // Тұрақ орындарының индексін алу функциясы
  int _getFlatIndex(int rowIndex, int colIndex) {
    int flatIndex = 0;
    for (int i = 0; i < rowIndex; i++) {
      flatIndex += parkingStatus[i].length;
    }
    return flatIndex + colIndex + 1;
  }
  // Уақытты форматтау функциясы
  String formatTimeRemaining(int expirationTime) {
    int secondsRemaining = expirationTime - DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (secondsRemaining <= 0) {
      return 'Expired';
    }
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Таймерді тоқтату
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Артқа қайту
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(translation(context).parkingPlaces),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
            child: Text(
              '${translation(context).address} $parkingAddress',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.local_parking),
                title: Text(translation(context).freePlaces),
                trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(width: 10),
                // Барлық орындарды көрсету батырмасы
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (filterType == FilterType.all) return Colors.blue;
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
                // Бос орындарды көрсету батырмасы
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (filterType == FilterType.free) return Colors.blue;
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
                // Брондалған және бос емес орындарды көрсету батырмасы
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (filterType == FilterType.occupied) return Colors.blue;
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
          Expanded(
            child: ListView(
              children: List.generate(parkingStatus.length, (rowIndex) {
                return Column(
                  children: [
                    Text('${translation(context).row} ${rowIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(parkingStatus[rowIndex].length, (index) {
                          int flatIndex = _getFlatIndex(rowIndex, index);
                          bool isReserved = reservations.containsKey(flatIndex);

                          if (filterType == FilterType.free && (parkingStatus[rowIndex][index] || isReserved)) {
                            return Container();
                          } else if (filterType == FilterType.occupied && !parkingStatus[rowIndex][index] && !isReserved) {
                            return Container();
                          }

                          Color spotColor = isReserved ? Colors.blue : (parkingStatus[rowIndex][index] ? Colors.red : Colors.green);

                          return GestureDetector(
                            onTap: () {
                              if (!parkingStatus[rowIndex][index] && !isReserved) {
                                reserveParkingSpot(rowIndex, index);
                              } else if (isReserved) {
                                _showCancelDialog(flatIndex);
                              }
                            },
                            child: Card(
                              child: Container(
                                width: 70,
                                height: 130,
                                margin: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: spotColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    isReserved
                                        ? Column(
                                      children: [
                                        Icon(Icons.timer, color: Colors.white, size: 30.0),
                                        Text(
                                          formatTimeRemaining(reservations[flatIndex]!),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                        : parkingStatus[rowIndex][index]
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
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                );
              }),
            ),
          ),
        ],
      ),
      // Фильтр түрлерін ауыстыру үшін FloatingActionButton
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
