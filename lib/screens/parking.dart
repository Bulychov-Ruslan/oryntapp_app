// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:oryntapp/language/language_constants.dart';
//
// // Автотұрақтар орындарын фильтрлеу түрлері
// enum FilterType { all, free, occupied }
//
// // Автотұрақ экраны
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   // Автотұрақ орындарының күйі
//   List<List<bool>> parkingStatus = [];
//   // Автотұрақ мекен-жайы
//   String parkingAddress = '';
//   // Таймер
//   Timer? _timer;
//   // Ағымдағы автотұрақ ID
//   String? currentParkingId;
//   // Бос орындар саны
//   int freeSpaces = 0;
//   // Бос емес орындар саны
//   int occupiedSpaces = 0;
//   // Фильтр түрі
//   FilterType filterType = FilterType.all;
//
//   @override
//   void initState() {
//     super.initState();
//     // Автотұрақ ID-сін алу
//     Future.delayed(Duration.zero, () {
//       currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
//       // Автотұрақ деректерін алу
//       fetchParkingData(currentParkingId!);
//       // Таймерді іске қосу
//       _timer = Timer.periodic(Duration(seconds: 1),
//               (Timer t) => fetchParkingData(currentParkingId!));
//     });
//   }
//   // Автотұрақ деректерін алу функциясы
//   Future<void> fetchParkingData(String parkingId) async {
//     // var url = 'http://10.0.2.2:5000/parkings/$parkingId';
//     var url = 'http://192.168.1.137:5000/parkings/$parkingId';
//     // var url = 'http://192.168.0.12:5000/parkings/$parkingId';
//     // var url = 'http://10.68.7.125:5000/parkings/$parkingId';
//     // Серверге HTTP запрос жасау
//     final response = await http.get(Uri.parse(url));
//     // Серверден деректерді алу
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         // Автотұрақ орындарының күйін жаңарту
//         parkingStatus =
//             rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
//         // Автотұрақ мекен-жайын жаңарту
//         parkingAddress = data['address'] as String;
//
//         // Бос және бос емес орындарды санау
//         freeSpaces = 0;
//         occupiedSpaces = 0;
//
//         // Автотұрақ орындарын санау
//         for (int i = 0; i < parkingStatus.length; i++) {
//           for (int j = 0; j < parkingStatus[i].length; j++) {
//             if (parkingStatus[i][j]) {
//               occupiedSpaces++;
//             } else {
//               freeSpaces++;
//             }
//           }
//         }
//       });
//     } else {
//       // Серверден деректерді алу мүмкін емес
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   @override
//   // Таймерді жою
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: Text(translation(context).parkingPlaces),
//       ),
//       body: Column(
//         children: <Widget>[
//           const SizedBox(height: 10),
//           // Автотұрақ мекен-жайы
//           Padding(
//             padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
//             child: Text(
//               '${translation(context).address} $parkingAddress',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           // Бос және бос емес орындарды саны
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.local_parking),
//                 title: Text(translation(context).freeSeats),
//                 trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.directions_car),
//                 title: Text(translation(context).occupiedPlaces),
//                 trailing: Text('$occupiedSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 10),
//
//           Text(translation(context).filter),
//           // Фильтрлеу түрлері
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.all)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.all;
//                     });
//                   },
//                   child: Text(translation(context).allPlaces, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.free)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.free;
//                     });
//                   },
//                   child: Text(translation(context).free, style: const TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.occupied)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.occupied;
//                     });
//                   },
//                   child: Text(translation(context).occupied, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 25),
//           // Автотұрақ орындары
//           Expanded(
//             child: ListView(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) {
//                   int previousItemsCount = 0;
//                   for (int k = 0; k < rowIndex; k++) {
//                     previousItemsCount += parkingStatus[k].length;
//                   }
//
//                   return Column(
//                     children: [
//                       Text('${translation(context).row} ${rowIndex + 1}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             parkingStatus[rowIndex].length,
//                                 (index) {
//                               if (filterType == FilterType.free && parkingStatus[rowIndex][index]) {
//                                 return Container();
//                               } else if (filterType == FilterType.occupied && !parkingStatus[rowIndex][index]) {
//                                 return Container();
//                               }
//                               int flatIndex = previousItemsCount + index + 1; // Нумерация начинается с 1
//                               return Card(
//                                 child: Container(
//                                   width: 70,
//                                   height: 130,
//                                   margin: EdgeInsets.all(6),
//                                   decoration: BoxDecoration(
//                                     color: parkingStatus[rowIndex][index]
//                                         ? Colors.red
//                                         : Colors.green,
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       parkingStatus[rowIndex][index]
//                                           ? Icon(Icons.directions_car, color: Colors.white, size: 50.0)
//                                           : Icon(Icons.local_parking, color: Colors.white, size: 50.0),
//
//                                       const SizedBox(height: 20),
//
//                                       Text(
//                                         '$flatIndex',
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20,)
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       // Фильтрлеу түрлерін ауыстыру үшін FloatingActionButton
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (filterType == FilterType.all) {
//               filterType = FilterType.free;
//             } else if (filterType == FilterType.free) {
//               filterType = FilterType.occupied;
//             } else {
//               filterType = FilterType.all;
//             }
//           });
//         },
//         child: const Icon(Icons.filter_list),
//       ),
//     );
//   }
// }
//


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:oryntapp/language/language_constants.dart';
//
// enum FilterType { all, free, occupied }
// enum ReservationStatus { free, occupied, reserved }
//
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<ReservationStatus>> parkingStatus = [];
//   Map<int, DateTime> reservationTimers = {};
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
//   int freeSpaces = 0;
//   int occupiedSpaces = 0;
//   FilterType filterType = FilterType.all;
//   Map<int, ReservationStatus> localChanges = {};
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
//       fetchParkingData(currentParkingId!);
//       _timer = Timer.periodic(Duration(seconds: 1),
//               (Timer t) => fetchParkingData(currentParkingId!));
//     });
//   }
//
//   Future<void> fetchParkingData(String parkingId) async {
//     var url = 'http://192.168.1.137:5000/parkings/$parkingId';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         parkingStatus = rows.map((row) {
//           return List<ReservationStatus>.from(
//               row.map((status) => status ? ReservationStatus.occupied : ReservationStatus.free));
//         }).toList();
//         parkingAddress = data['address'] as String;
//
//         freeSpaces = 0;
//         occupiedSpaces = 0;
//
//         for (int rowIndex = 0; rowIndex < parkingStatus.length; rowIndex++) {
//           for (int index = 0; index < parkingStatus[rowIndex].length; index++) {
//             int flatIndex = calculateFlatIndex(rowIndex, index);
//             if (localChanges.containsKey(flatIndex)) {
//               parkingStatus[rowIndex][index] = localChanges[flatIndex]!;
//             }
//             if (parkingStatus[rowIndex][index] != ReservationStatus.free) {
//               occupiedSpaces++;
//             } else {
//               freeSpaces++;
//             }
//           }
//         }
//       });
//     } else {
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   Future<void> bookSpace(int rowIndex, int index) async {
//     int flatIndex = calculateFlatIndex(rowIndex, index);
//     final selectedDuration = await showDialog<Duration>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: Text('Select duration'),
//           children: <Widget>[
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 1));
//               },
//               child: const Text('1 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 10));
//               },
//               child: const Text('10 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 20));
//               },
//               child: const Text('20 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 30));
//               },
//               child: const Text('30 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 60));
//               },
//               child: const Text('1 hour'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (selectedDuration != null) {
//       setState(() {
//         parkingStatus[rowIndex][index] = ReservationStatus.reserved;
//         localChanges[flatIndex] = ReservationStatus.reserved;
//         reservationTimers[flatIndex] = DateTime.now().add(selectedDuration);
//         freeSpaces--;
//         occupiedSpaces++;
//       });
//     }
//   }
//
//   Future<void> cancelReservation(int rowIndex, int index) async {
//     final confirmCancel = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Cancel reservation'),
//           content: Text('Are you sure you want to cancel the reservation?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmCancel == true) {
//       setState(() {
//         int flatIndex = calculateFlatIndex(rowIndex, index);
//         parkingStatus[rowIndex][index] = ReservationStatus.free;
//         localChanges[flatIndex] = ReservationStatus.free;
//         reservationTimers.remove(flatIndex);
//         freeSpaces++;
//         occupiedSpaces--;
//       });
//     }
//   }
//
//   void updateReservationTimers() {
//     setState(() {
//       final now = DateTime.now();
//       List<int> expiredTimers = [];
//       reservationTimers.forEach((key, value) {
//         if (value.isBefore(now)) {
//           expiredTimers.add(key);
//         }
//       });
//
//       for (int key in expiredTimers) {
//         int rowIndex = 0;
//         int cumulativeIndex = key;
//
//         for (int i = 0; i < parkingStatus.length; i++) {
//           if (cumulativeIndex < parkingStatus[i].length) {
//             rowIndex = i;
//             break;
//           } else {
//             cumulativeIndex -= parkingStatus[i].length;
//           }
//         }
//
//         int index = cumulativeIndex;
//
//         parkingStatus[rowIndex][index] = ReservationStatus.free;
//         localChanges[key] = ReservationStatus.free;
//         reservationTimers.remove(key);
//         freeSpaces++;
//         occupiedSpaces--;
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   int calculateFlatIndex(int rowIndex, int index) {
//     int flatIndex = 0;
//     for (int i = 0; i < rowIndex; i++) {
//       flatIndex += parkingStatus[i].length;
//     }
//     flatIndex += index;
//     return flatIndex;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     updateReservationTimers();
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: Text(translation(context).parkingPlaces),
//       ),
//       body: Column(
//         children: <Widget>[
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
//             child: Text(
//               '${translation(context).address} $parkingAddress',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.local_parking),
//                 title: Text(translation(context).freeSeats),
//                 trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.directions_car),
//                 title: Text(translation(context).occupiedPlaces),
//                 trailing: Text('$occupiedSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(translation(context).filter),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.all)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.all;
//                     });
//                   },
//                   child: Text(translation(context).allPlaces, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.free)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.free;
//                     });
//                   },
//                   child: Text(translation(context).free, style: const TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.occupied)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.occupied;
//                     });
//                   },
//                   child: Text(translation(context).occupied, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//           const SizedBox(height: 25),
//           Expanded(
//             child: ListView(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) {
//                   return Column(
//                     children: [
//                       Text('${translation(context).row} ${rowIndex + 1}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             parkingStatus[rowIndex].length,
//                                 (index) {
//                               if (filterType == FilterType.free &&
//                                   parkingStatus[rowIndex][index] != ReservationStatus.free) {
//                                 return Container();
//                               } else if (filterType == FilterType.occupied &&
//                                   parkingStatus[rowIndex][index] == ReservationStatus.free) {
//                                 return Container();
//                               }
//                               int flatIndex = calculateFlatIndex(rowIndex, index) + 1; // Нумерация начинается с 1
//                               return GestureDetector(
//                                 onTap: () {
//                                   if (parkingStatus[rowIndex][index] == ReservationStatus.free) {
//                                     bookSpace(rowIndex, index);
//                                   } else if (parkingStatus[rowIndex][index] ==
//                                       ReservationStatus.reserved) {
//                                     cancelReservation(rowIndex, index);
//                                   }
//                                 },
//                                 child: Card(
//                                   child: Container(
//                                     width: 70,
//                                     height: 130,
//                                     margin: EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: parkingStatus[rowIndex][index] == ReservationStatus.occupied
//                                           ? Colors.red
//                                           : parkingStatus[rowIndex][index] == ReservationStatus.reserved
//                                           ? Colors.blue
//                                           : Colors.green,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         parkingStatus[rowIndex][index] == ReservationStatus.occupied
//                                             ? Icon(Icons.directions_car, color: Colors.white, size: 50.0)
//                                             : Icon(Icons.local_parking, color: Colors.white, size: 50.0),
//                                         const SizedBox(height: 20),
//                                         Text(
//                                           '$flatIndex',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                         if (parkingStatus[rowIndex][index] ==
//                                             ReservationStatus.reserved)
//                                           if (reservationTimers.containsKey(calculateFlatIndex(rowIndex, index)))
//                                             Text(
//                                               _formatDuration(reservationTimers[calculateFlatIndex(rowIndex, index)]!.difference(DateTime.now())),
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20,)
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (filterType == FilterType.all) {
//               filterType = FilterType.free;
//             } else if (filterType == FilterType.free) {
//               filterType = FilterType.occupied;
//             } else {
//               filterType = FilterType.all;
//             }
//           });
//         },
//         child: const Icon(Icons.filter_list),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// import 'package:oryntapp/language/language_constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// enum FilterType { all, free, occupied }
// enum ReservationStatus { free, occupied, reserved }
//
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<ReservationStatus>> parkingStatus = [];
//   Map<int, DateTime> reservationTimers = {};
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
//   int freeSpaces = 0;
//   int occupiedSpaces = 0;
//   FilterType filterType = FilterType.all;
//   Map<int, ReservationStatus> localChanges = {};
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
//       loadReservationState(); // Загрузка состояния бронирования
//       fetchParkingData(currentParkingId!);
//       _timer = Timer.periodic(Duration(seconds: 1),
//               (Timer t) => fetchParkingData(currentParkingId!));
//     });
//   }
//
//   Future<void> fetchParkingData(String parkingId) async {
//     var url = 'http://192.168.1.137:5000/parkings/$parkingId';
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         parkingStatus = rows.map((row) {
//           return List<ReservationStatus>.from(
//               row.map((status) => status ? ReservationStatus.occupied : ReservationStatus.free));
//         }).toList();
//         parkingAddress = data['address'] as String;
//
//         freeSpaces = 0;
//         occupiedSpaces = 0;
//
//         for (int rowIndex = 0; rowIndex < parkingStatus.length; rowIndex++) {
//           for (int index = 0; index < parkingStatus[rowIndex].length; index++) {
//             int flatIndex = calculateFlatIndex(rowIndex, index);
//             if (localChanges.containsKey(flatIndex)) {
//               parkingStatus[rowIndex][index] = localChanges[flatIndex]!;
//             }
//             if (parkingStatus[rowIndex][index] != ReservationStatus.free) {
//               occupiedSpaces++;
//             } else {
//               freeSpaces++;
//             }
//           }
//         }
//       });
//     } else {
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   Future<void> bookSpace(int rowIndex, int index) async {
//     int flatIndex = calculateFlatIndex(rowIndex, index);
//     final selectedDuration = await showDialog<Duration>(
//       context: context,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: Text(''),
//           children: <Widget>[
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 10));
//               },
//               child: const Text('10 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 20));
//               },
//               child: const Text('20 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 30));
//               },
//               child: const Text('30 minutes'),
//             ),
//             SimpleDialogOption(
//               onPressed: () {
//                 Navigator.pop(context, Duration(minutes: 60));
//               },
//               child: const Text('1 hour'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (selectedDuration != null) {
//       setState(() {
//         parkingStatus[rowIndex][index] = ReservationStatus.reserved;
//         localChanges[flatIndex] = ReservationStatus.reserved;
//         reservationTimers[flatIndex] = DateTime.now().add(selectedDuration);
//         saveReservationState(); // Сохранение состояния бронирования
//         freeSpaces--;
//         occupiedSpaces++;
//       });
//     }
//   }
//
//   Future<void> cancelReservation(int rowIndex, int index) async {
//     final confirmCancel = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(''),
//           content: Text(''),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmCancel == true) {
//       setState(() {
//         int flatIndex = calculateFlatIndex(rowIndex, index);
//         parkingStatus[rowIndex][index] = ReservationStatus.free;
//         localChanges[flatIndex] = ReservationStatus.free;
//         reservationTimers.remove(flatIndex);
//         saveReservationState(); // Сохранение состояния бронирования
//         freeSpaces++;
//         occupiedSpaces--;
//       });
//     }
//   }
//
//   void updateReservationTimers() {
//     setState(() {
//       final now = DateTime.now();
//       List<int> expiredTimers = [];
//       reservationTimers.forEach((key, value) {
//         if (value.isBefore(now)) {
//           expiredTimers.add(key);
//         }
//       });
//
//       for (int key in expiredTimers) {
//         int rowIndex = 0;
//         int cumulativeIndex = key;
//
//         if (parkingStatus.isEmpty) return; // Проверка на пустоту списка
//
//         for (int i = 0; i < parkingStatus.length; i++) {
//           if (cumulativeIndex < parkingStatus[i].length) {
//             rowIndex = i;
//             break;
//           } else {
//             cumulativeIndex -= parkingStatus[i].length;
//           }
//         }
//
//         if (rowIndex >= parkingStatus.length || cumulativeIndex >= parkingStatus[rowIndex].length) return; // Проверка на валидность индексов
//
//         int index = cumulativeIndex;
//
//         parkingStatus[rowIndex][index] = ReservationStatus.free;
//         localChanges[key] = ReservationStatus.free;
//         reservationTimers.remove(key);
//         freeSpaces++;
//         occupiedSpaces--;
//       }
//     });
//   }
//
//   Future<void> saveReservationState() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> reservations = reservationTimers.entries.map((entry) {
//       return '${entry.key}:${entry.value.toIso8601String()}';
//     }).toList();
//     await prefs.setStringList('reservations', reservations);
//
//     List<String> localStatus = localChanges.entries.map((entry) {
//       return '${entry.key}:${entry.value.index}';
//     }).toList();
//     await prefs.setStringList('localStatus', localStatus);
//   }
//
//   Future<void> loadReservationState() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? reservations = prefs.getStringList('reservations');
//     if (reservations != null) {
//       reservationTimers = {
//         for (var reservation in reservations)
//           int.parse(reservation.split(':')[0]): DateTime.parse(reservation.split(':')[1])
//       };
//     }
//
//     List<String>? localStatus = prefs.getStringList('localStatus');
//     if (localStatus != null) {
//       localChanges = {
//         for (var status in localStatus)
//           int.parse(status.split(':')[0]): ReservationStatus.values[int.parse(status.split(':')[1])]
//       };
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     saveReservationState(); // Сохранение состояния бронирования
//     super.dispose();
//   }
//
//   int calculateFlatIndex(int rowIndex, int index) {
//     int flatIndex = 0;
//     for (int i = 0; i < rowIndex; i++) {
//       flatIndex += parkingStatus[i].length;
//     }
//     flatIndex += index;
//     return flatIndex;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     updateReservationTimers();
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//         title: Text(translation(context).parkingPlaces),
//       ),
//       body: Column(
//         children: <Widget>[
//           const SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
//             child: Text(
//               '${translation(context).address} $parkingAddress',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.local_parking),
//                 title: Text(translation(context).freeSeats),
//                 trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 10.0,
//               right: 10.0,
//             ),
//             child: Card(
//               child: ListTile(
//                 leading: const Icon(Icons.directions_car),
//                 title: Text(translation(context).occupiedPlaces),
//                 trailing: Text('$occupiedSpaces', style: const TextStyle(fontSize: 16)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(translation(context).filter),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.all)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.all;
//                     });
//                   },
//                   child: Text(translation(context).allPlaces, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.free)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.free;
//                     });
//                   },
//                   child: Text(translation(context).free, style: const TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                         if (filterType == FilterType.occupied)
//                           return Colors.blue;
//                         return Colors.grey;
//                       },
//                     ),
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       filterType = FilterType.occupied;
//                     });
//                   },
//                   child: Text(translation(context).occupied, style: TextStyle(color: Colors.white)),
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//           ),
//           const SizedBox(height: 25),
//           Expanded(
//             child: ListView(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) {
//                   return Column(
//                     children: [
//                       Text('${translation(context).row} ${rowIndex + 1}',
//                           style: const TextStyle(fontWeight: FontWeight.bold)),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             parkingStatus[rowIndex].length,
//                                 (index) {
//                               if (filterType == FilterType.free &&
//                                   parkingStatus[rowIndex][index] != ReservationStatus.free) {
//                                 return Container();
//                               } else if (filterType == FilterType.occupied &&
//                                   parkingStatus[rowIndex][index] == ReservationStatus.free) {
//                                 return Container();
//                               }
//                               int flatIndex = calculateFlatIndex(rowIndex, index) + 1;
//                               return GestureDetector(
//                                 onTap: () {
//                                   if (parkingStatus[rowIndex][index] == ReservationStatus.free) {
//                                     bookSpace(rowIndex, index);
//                                   } else if (parkingStatus[rowIndex][index] ==
//                                       ReservationStatus.reserved) {
//                                     cancelReservation(rowIndex, index);
//                                   }
//                                 },
//                                 child: Card(
//                                   child: Container(
//                                     width: 70,
//                                     height: 130,
//                                     margin: EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: parkingStatus[rowIndex][index] == ReservationStatus.occupied
//                                           ? Colors.red
//                                           : parkingStatus[rowIndex][index] == ReservationStatus.reserved
//                                           ? Colors.blue
//                                           : Colors.green,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: <Widget>[
//                                         parkingStatus[rowIndex][index] == ReservationStatus.occupied
//                                             ? Icon(Icons.directions_car, color: Colors.white, size: 50.0)
//                                             : Icon(Icons.local_parking, color: Colors.white, size: 50.0),
//                                         const SizedBox(height: 20),
//                                         Text(
//                                           '$flatIndex',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 20,
//                                           ),
//                                         ),
//                                         if (parkingStatus[rowIndex][index] ==
//                                             ReservationStatus.reserved)
//                                           if (reservationTimers.containsKey(calculateFlatIndex(rowIndex, index)))
//                                             Text(
//                                               _formatDuration(reservationTimers[calculateFlatIndex(rowIndex, index)]!.difference(DateTime.now())),
//                                               style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16,
//                                               ),
//                                             ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20,)
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (filterType == FilterType.all) {
//               filterType = FilterType.free;
//             } else if (filterType == FilterType.free) {
//               filterType = FilterType.occupied;
//             } else {
//               filterType = FilterType.all;
//             }
//           });
//         },
//         child: const Icon(Icons.filter_list),
//       ),
//     );
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

enum FilterType { all, free, occupied }

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  _ParkingScreenState createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  List<List<bool>> parkingStatus = [];
  Map<int, int> reservations = {};
  String parkingAddress = '';
  Timer? _timer;
  String? currentParkingId;
  int freeSpaces = 0;
  int occupiedSpaces = 0;
  FilterType filterType = FilterType.all;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
      fetchParkingData(currentParkingId!);
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchParkingData(currentParkingId!));
    });
  }

  Future<void> fetchParkingData(String parkingId) async {
    var url = 'http://192.168.1.137:5000/parkings/$parkingId';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        List<dynamic> rows = data['status'] as List<dynamic>;
        parkingStatus = rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
        parkingAddress = data['address'] as String;

        freeSpaces = 0;
        occupiedSpaces = 0;

        for (int i = 0; i < parkingStatus.length; i++) {
          for (int j = 0; j < parkingStatus[i].length; j++) {
            if (parkingStatus[i][j]) {
              occupiedSpaces++;
            } else {
              freeSpaces++;
            }
          }
        }

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

  Future<void> reserveParkingSpot(int rowIndex, int colIndex) async {
    int flatIndex = _getFlatIndex(rowIndex, colIndex);
    Duration? duration = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Select reservation duration'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 5));
              },
              child: const Text('5 minutes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 10));
              },
              child: const Text('10 minutes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Duration(minutes: 20));
              },
              child: const Text('20 minutes'),
            ),
          ],
        );
      },
    );

    if (duration != null) {
      var url = 'http://192.168.1.137:5000/reserve';
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
        fetchParkingData(currentParkingId!);
      } else {
        // Handle reservation error
        print('Failed to reserve parking spot');
      }
    }
  }

  Future<void> cancelReservation(int flatIndex) async {
    var url = 'http://192.168.1.137:5000/cancel_reservation';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'parkingId': currentParkingId,
        'spotIndex': flatIndex,
      }),
    );

    if (response.statusCode == 200) {
      fetchParkingData(currentParkingId!);
    } else {
      // Handle cancellation error
      print('Failed to cancel reservation');
    }
  }

  Future<void> _showCancelDialog(int flatIndex) async {
    bool confirmCancel = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: Text('Are you sure you want to cancel the reservation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmCancel) {
      cancelReservation(flatIndex);
    }
  }

  int _getFlatIndex(int rowIndex, int colIndex) {
    int flatIndex = 0;
    for (int i = 0; i < rowIndex; i++) {
      flatIndex += parkingStatus[i].length;
    }
    return flatIndex + colIndex + 1;
  }

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
        title: Text('Parking Places'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
            child: Text(
              'Address: $parkingAddress',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.local_parking),
                title: Text('Free Seats'),
                trailing: Text('$freeSpaces', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text('Occupied Places'),
                trailing: Text('$occupiedSpaces', style: const TextStyle(fontSize: 16)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text('Filter'),
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
                  child: Text('All Places', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
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
                  child: Text('Free', style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
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
                  child: Text('Occupied', style: TextStyle(color: Colors.white)),
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
                    Text('Row ${rowIndex + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
