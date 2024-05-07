import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:oryntapp/language/language_constants.dart';

class MapParkingScreen extends StatefulWidget {
  const MapParkingScreen({super.key});

  @override
  State<MapParkingScreen> createState() => _MapParkingScreenState();
}

class _MapParkingScreenState extends State<MapParkingScreen> {
  bool _isRouteButtonPressed = false;

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pBaitursynov1 = LatLng(43.2389, 76.9279);
  static const LatLng _pBaitursynov2 = LatLng(43.2402, 76.9277);
  static const LatLng _pKazNu = LatLng(43.2262, 76.9213);
  static const LatLng _pSatbayevGuk = LatLng(43.2368, 76.9303);
  static const LatLng _pSatbayevGMK = LatLng(43.2365, 76.9306);

  LatLng? _currentP = null;

  BitmapDescriptor? _userLocationIcon;
  BitmapDescriptor? _parkingIcon;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _loadCustomIcons().then((_) {
      getLocationUpdates();
    });
  }

  Future<void> _loadCustomIcons() async {
    _userLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/user_location_icon.png');
    _parkingIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/parking_icon.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).parkingMap),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getLocationUpdates();
            },
          ),
        ],
      ),
      body: _currentP == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _currentP!,
                zoom: 12.2,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("_currentLocation"),
                  icon: _userLocationIcon ?? BitmapDescriptor.defaultMarker,
                  position: _currentP!,
                ),
                Marker(
                  markerId: MarkerId("ParkingLocation1"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pBaitursynov1,
                  onTap: () {
                    showMarkerDialog(context, _currentP!, _pBaitursynov1,
                        "1");
                  },
                ),
                Marker(
                  markerId: MarkerId("ParkingLocation2"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pBaitursynov2,
                  onTap: () {
                    showMarkerDialog(
                        context, _currentP!, _pBaitursynov2, "2");
                  },
                ),
                Marker(
                  markerId: MarkerId("ParkingLocation3"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pKazNu,
                  onTap: () {
                    showMarkerDialog(
                        context, _currentP!, _pKazNu, "3");
                  },
                ),
                Marker(
                  markerId: MarkerId("ParkingLocation4"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pSatbayevGuk,
                  onTap: () {
                    showMarkerDialog(
                        context, _currentP!, _pSatbayevGuk, "4");
                  },
                ),
                Marker(
                  markerId: MarkerId("ParkingLocation5"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pSatbayevGMK,
                  onTap: () {
                    showMarkerDialog(
                        context, _currentP!, _pSatbayevGMK, "5");
                  },
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              zoomControlsEnabled: true,
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(translation(context).locationDisabled),
            content: Text(
              translation(context).enableLocationToUseThisApp,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(translation(context).enableLocation),
                onPressed: () async {
                  _serviceEnabled = await _locationController.requestService();
                  if (_serviceEnabled) {
                    Navigator.of(context).pop();
                    getLocationUpdates();
                  }
                },
              ),
            ],
          );
        },
      );
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            if (_isRouteButtonPressed) {
              _cameraToPosition(_currentP!);
            }
          });
        }
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints(LatLng start, LatLng end) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyADgX6ekT8Y1FctQNZ9mFWuDlvTJbxU_uQ',
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  void showMarkerDialog(
      BuildContext context, LatLng currentP, LatLng markerP, String parkingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).chooseAnAction),
          actions: <Widget>[
            Column(
              children: <Widget>[
                TextButton(
                child: Text(translation(context).viewParking),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/parking', arguments: parkingId);
                },
              ),
                TextButton(
                  child: Text(translation(context).buildARoute),
                  onPressed: () {
                    getPolylinePoints(currentP, markerP).then((coordinates) {
                      generatePolyLineFromPoints(coordinates);
                      _isRouteButtonPressed = true;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
