//
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<bool>> parkingStatus = [];
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
//       fetchParkingData(currentParkingId!);
//       _timer = Timer.periodic(Duration(seconds: 1),
//           (Timer t) => fetchParkingData(currentParkingId!));
//     });
//   }
//
//   Future<void> fetchParkingData(String parkingId) async {
//     try {
//       // var url = 'http://10.0.2.2:5000/parkings/$parkingId'; // Для Эмулятора
//       // var url = 'http://192.168.68.137:5000/parkings/$parkingId'; // Для Мобильного устройства с мобильным интернетом
//       var url = 'http://192.168.0.13:5000/parkings/$parkingId';
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           List<dynamic> rows = data['status'] as List<dynamic>;
//           parkingStatus =
//               rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
//           parkingAddress = data['address'] as String;
//         });
//       } else {
//         throw Exception('Failed to load parking data');
//       }
//     } catch (e) {
//       print('Error fetching parking data: $e');
//     }
//   }
//
//   @override
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
//         title: Text('Парковочные места'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Адрес: $parkingAddress',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: EdgeInsets.all(10),
//               itemCount: parkingStatus.length,
//               itemBuilder: (context, rowIndex) {
//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text('Ряд ${rowIndex + 1}',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: parkingStatus[rowIndex].length,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                       ),
//                       itemCount: parkingStatus[rowIndex].length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: parkingStatus[rowIndex][index]
//                                 ? Colors.red
//                                 : Colors.green,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               '${index + 1}',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<bool>> parkingStatus = [];
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
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
//     var url = 'http://192.168.0.13:5000/parkings/$parkingId';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         parkingStatus =
//             rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
//         parkingAddress = data['address'] as String;
//       });
//     } else {
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   @override
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
//         title: Text('Парковочные места'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Адрес: $parkingAddress',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: Row(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) => Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: parkingStatus[rowIndex].length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         height: 50,
//                         margin: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: parkingStatus[rowIndex][index]
//                               ? Colors.red
//                               : Colors.green,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             '${index + 1}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
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
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({super.key});
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<bool>> parkingStatus = [];
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       currentParkingId = ModalRoute.of(context)!.settings.arguments as String;
//       fetchParkingData(currentParkingId!);
//       _timer = Timer.periodic(Duration(seconds: 1),
//           (Timer t) => fetchParkingData(currentParkingId!));
//     });
//   }
//
//   Future<void> fetchParkingData(String parkingId) async {
//     var url = 'http://192.168.0.13:5000/parkings/$parkingId';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         parkingStatus =
//             rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
//         parkingAddress = data['address'] as String;
//       });
//     } else {
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   @override
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
//         title: Text('Парковочные места'),
//       ),
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Адрес: $parkingAddress',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 50,),
//           Expanded(
//             child: ListView(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) {
//                   return Column(
//                     children: [
//                       Text('Ряд ${rowIndex + 1}',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             parkingStatus[rowIndex].length,
//                                 (index) {
//                               // Преобразование одномерного индекса в двумерный
//                               int flatIndex = rowIndex * parkingStatus[rowIndex].length + index;
//                               flatIndex += 1;
//                               return Container(
//                                 width: 80,
//                                 height: 140,
//                                 margin: EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: parkingStatus[rowIndex][index]
//                                       ? Colors.red
//                                       : Colors.green,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '$flatIndex',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 80,)
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
//
// class ParkingScreen extends StatefulWidget {
//   const ParkingScreen({Key? key}) : super(key: key);
//
//   @override
//   _ParkingScreenState createState() => _ParkingScreenState();
// }
//
// class _ParkingScreenState extends State<ParkingScreen> {
//   List<List<bool>> parkingStatus = [];
//   String parkingAddress = '';
//   Timer? _timer;
//   String? currentParkingId;
//   int freeSpaces = 0;
//   int occupiedSpaces = 0;
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
//     var url = 'http://192.168.0.13:5000/parkings/$parkingId';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         List<dynamic> rows = data['status'] as List<dynamic>;
//         parkingStatus =
//             rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
//         parkingAddress = data['address'] as String;
//
//         // Reset counts
//         freeSpaces = 0;
//         occupiedSpaces = 0;
//
//         // Calculate counts
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
//       throw Exception('Failed to load parking data');
//     }
//   }
//
//   @override
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
//         title: Text('Парковочные места'),
//       ),
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 10),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Адрес: $parkingAddress',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 10,),
//           Text('Свободных мест: $freeSpaces'),
//           Text('Занятых мест: $occupiedSpaces'),
//           SizedBox(height: 20,),
//           Expanded(
//             child: ListView(
//               children: List.generate(
//                 parkingStatus.length,
//                     (rowIndex) {
//                   return Column(
//                     children: [
//                       Text('Ряд ${rowIndex + 1}',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             parkingStatus[rowIndex].length,
//                                 (index) {
//                               // Преобразование одномерного индекса в двумерный
//                               int flatIndex = rowIndex * parkingStatus[rowIndex].length + index;
//                               flatIndex += 1;
//                               return Container(
//                                 width: 80,
//                                 height: 140,
//                                 margin: EdgeInsets.all(6),
//                                 decoration: BoxDecoration(
//                                   color: parkingStatus[rowIndex][index]
//                                       ? Colors.red
//                                       : Colors.green,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     '$flatIndex',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20,)
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
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
      _timer = Timer.periodic(Duration(seconds: 1),
              (Timer t) => fetchParkingData(currentParkingId!));
    });
  }

  Future<void> fetchParkingData(String parkingId) async {
    var url = 'http://192.168.0.13:5000/parkings/$parkingId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        List<dynamic> rows = data['status'] as List<dynamic>;
        parkingStatus =
            rows.map((row) => List<bool>.from(row as List<dynamic>)).toList();
        parkingAddress = data['address'] as String;

        // Reset counts
        freeSpaces = 0;
        occupiedSpaces = 0;

        // Calculate counts
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
      throw Exception('Failed to load parking data');
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text('Парковочные места'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Адрес: $parkingAddress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 10,),

          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.local_parking, color: Colors.blue),
                title: Text('Свободных мест'),
                trailing: Text('$freeSpaces', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            child: Card(
              child: ListTile(
                leading: Icon(Icons.directions_car, color: Colors.red),
                title: Text('Занятых мест'),
                trailing: Text('$occupiedSpaces', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),

          SizedBox(height: 10,),

          Text('Фильтр:'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('Все места', style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.all)
                          return Colors.blue; // Use the component's default.
                        return Colors.grey; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.all;
                    });
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('Свободные', style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.free)
                          return Colors.blue; // Use the component's default.
                        return Colors.grey; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.free;
                    });
                  },
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  child: Text('Занятые', style: TextStyle(color: Colors.white),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (filterType == FilterType.occupied)
                          return Colors.blue; // Use the component's default.
                        return Colors.grey; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      filterType = FilterType.occupied;
                    });
                  },
                ),
                SizedBox(width: 10),
              ],
            ),
          ),

          SizedBox(height: 30,),

          Expanded(
            child: ListView(
              children: List.generate(
                parkingStatus.length,
                    (rowIndex) {
                  return Column(
                    children: [
                      Text('Ряд ${rowIndex + 1}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            parkingStatus[rowIndex].length,
                                (index) {
                              if (filterType == FilterType.free && parkingStatus[rowIndex][index]) {
                                return Container(); // Empty container for occupied spaces when filter is 'free'
                              } else if (filterType == FilterType.occupied && !parkingStatus[rowIndex][index]) {
                                return Container(); // Empty container for free spaces when filter is 'occupied'
                              }
                              // Преобразование одномерного индекса в двумерный
                              int flatIndex = rowIndex * parkingStatus[rowIndex].length + index;
                              flatIndex += 1;
                              return Card(
                                child: Container(
                                  width: 80,
                                  height: 140,
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

                                      SizedBox(height: 20),

                                      Text(
                                        '$flatIndex',
                                        style: TextStyle(
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
                      SizedBox(height: 20,)
                    ],
                  );
                },
              ),
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
        child: Icon(Icons.filter_list),
      ),
    );
  }
}






