import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isRouteButtonPressed = false;

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(43.2356, 76.9297);
  static const LatLng _pApplePark = LatLng(43.2255, 76.922);
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
        title: const Text('Карта парковок'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
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
                  markerId: MarkerId("sourceLocation"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pGooglePlex,
                  onTap: () {
                    showMarkerDialog(context, _currentP!, _pGooglePlex,
                        "1"); // ID парковки 1
                  },
                ),
                Marker(
                  markerId: MarkerId("destinationLocation"),
                  icon: _parkingIcon ?? BitmapDescriptor.defaultMarker,
                  position: _pApplePark,
                  onTap: () {
                    showMarkerDialog(
                        context, _currentP!, _pApplePark, "2"); // ID парковки 2
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
            title: Text('Местоположение отключено'),
            content: Text(
                'Включите местоположение для использования этого приложения'),
            actions: <Widget>[
              TextButton(
                child: Text('Включить местоположение'),
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
          title: Text('Выберите действие'),
          actions: <Widget>[
            TextButton(
              child: Text('Посмотреть парковку'),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/parking', arguments: parkingId);
              },
            ),
            TextButton(
              child: Text('Построить маршрут'),
              onPressed: () {
                getPolylinePoints(currentP, markerP).then((coordinates) {
                  generatePolyLineFromPoints(coordinates);
                  _isRouteButtonPressed = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
