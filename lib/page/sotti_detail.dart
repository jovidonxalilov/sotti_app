import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sotti/common/bottom_navigation_bar_widget.dart';
import '../navigation/routes.dart';
import '../provider.dart';

class SottiHomePage extends StatelessWidget {
  const SottiHomePage({super.key});
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
      bottomNavigationBar: BottomNavigationBarMap(selectedIndex: 0,
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