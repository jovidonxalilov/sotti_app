import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider.dart';

class SottiHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Sotti App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Latitude: ${locationProvider.lat}"),
            Text("Longitude: ${locationProvider.long}"),
            Text("Status: ${locationProvider.isWorking ? 'Shipiyon ishda' : 'Shipyon dam olyapti'}"),
            ElevatedButton(
              onPressed: () => locationProvider.toggleWorking(),
              child: Text("Holatni almashtirish"),
            )
          ],
        ),
      ),
    );
  }
}