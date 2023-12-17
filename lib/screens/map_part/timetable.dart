import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TimeTablePage extends StatelessWidget {
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final LatLng routelocation1;
  final LatLng routelocation2;
  final LatLng currentLatLng;
  final String routeId; // Add routeId parameter

  TimeTablePage({
    required this.fromLatLng,
    required this.toLatLng,
    required this.routelocation1,
    required this.routelocation2,
    required this.currentLatLng,
    required this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timetable'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From LatLng: $fromLatLng'),
            Text('To LatLng: $toLatLng'),
            Text('Location 1: $routelocation1'),
            Text('Location 2: $routelocation2'),
            Text('Current LatLng: $currentLatLng'),
            Text('Route ID: $routeId'), // Display routeId
            // Add more timetable details or components as needed
          ],
        ),
      ),
    );
  }
}