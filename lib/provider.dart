import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class LocationProvider with ChangeNotifier {
  Location _location = Location();
  double? lat;
  double? long;
  bool isWorking = false;
  double? _lastLat;
  double? _lastLong;

  LocationProvider() {
    _initLocation();
  }

  void toggleWorking() {
    isWorking = !isWorking;
    notifyListeners();
    _updateFirestore();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await _location.requestService();

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    _location.onLocationChanged.listen((loc) {
      if (_shouldUpdate(loc.latitude!, loc.longitude!)) {
        lat = loc.latitude;
        long = loc.longitude;
        _lastLat = lat;
        _lastLong = long;
        _updateFirestore();
        notifyListeners();
      }
    });
  }

  bool _shouldUpdate(double newLat, double newLong) {
    if (_lastLat == null || _lastLong == null) return true;
    double distance = _calculateDistance(_lastLat!, _lastLong!, newLat, newLong);
    return distance >= 30;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * pi / 180;

  void _updateFirestore() {
    FirebaseFirestore.instance.collection('location').doc('shipiyon').set({
      'lat': lat,
      'long': long,
      'isWorking': isWorking,
    });
  }
}