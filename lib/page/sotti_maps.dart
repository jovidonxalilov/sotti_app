import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../common/bottom_navigation_bar_widget.dart';
import '../navigation/routes.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class SottiMaps extends StatefulWidget {
  const SottiMaps({Key? key}) : super(key: key);

  @override
  State<SottiMaps> createState() => _SottiMapsState();
}

class _SottiMapsState extends State<SottiMaps> {
  final Location _location = Location();
  GoogleMapController? _mapController;
  StreamSubscription<LocationData>? _locationSubscription;

  List<LatLng> _pathPoints = [];
  Set<Marker> _markers = {};
  Polyline _polyline = Polyline(
    polylineId: PolylineId("movement"),
    color: Colors.blue,
    width: 4,
    points: [],
  );

  LatLng? _lastSavedLatLng;

  @override
  void initState() {
    super.initState();
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.changeSettings(interval: 2000, distanceFilter: 1);

    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      final currentLatLng = LatLng(locationData.latitude!, locationData.longitude!);

      if (_lastSavedLatLng == null) {
        _addMarker(currentLatLng);
        _lastSavedLatLng = currentLatLng;
        return;
      }

      final distance = _calculateDistance(
        _lastSavedLatLng!.latitude,
        _lastSavedLatLng!.longitude,
        currentLatLng.latitude,
        currentLatLng.longitude,
      );

      if (distance >= 10) {
        _addMarker(currentLatLng);
        _lastSavedLatLng = currentLatLng;
      }

      _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
    });
  }

  void _addMarker(LatLng position) {
    if (_markers.length >= 10) {
      _markers.remove(_markers.first);
      _pathPoints.removeAt(0);
    }

    final markerId = MarkerId("marker_${DateTime.now().millisecondsSinceEpoch}");
    _markers.add(Marker(markerId: markerId, position: position));
    _pathPoints.add(position);

    setState(() {
      _polyline = _polyline.copyWith(pointsParam: _pathPoints);
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Jonli Joylashuv")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(41.311081, 69.240562),
          zoom: 17,
        ),
        markers: _markers,
        polylines: {_polyline},
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      bottomNavigationBar: BottomNavigationBarMap(selectedIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              context.push(Routes.home);
              break;
            case 1:
              context.push(Routes.map);
              break;
          }
        },),
    );
  }
}

