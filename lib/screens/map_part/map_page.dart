import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  final LatLng fromLatLng;
  final LatLng toLatLng;
  final LatLng routelocation1;
  final LatLng routelocation2;
  final LatLng currentLatLng;
  final String routeId; // New parameter
  final String routeName; // New parameter

  MapPage({
    required this.fromLatLng,
    required this.toLatLng,
    required this.routelocation1,
    required this.routelocation2,
    required this.currentLatLng,
    required this.routeId,
    required this.routeName,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  // ignore: unused_field
  late LatLng _lastKnownPosition;
  List<LatLng> _driverLocations = [];
  // ignore: unused_field
  List<String> _busName = [];
  // ignore: unused_field
  List<int> _seatCount = [];

  final databaseReference = FirebaseDatabase.instance.ref();
  StreamSubscription<DatabaseEvent>? _firebaseSubscription;

  @override
  void initState() {
    super.initState();

    _lastKnownPosition = widget.currentLatLng;
    _markers
      ..add(Marker(markerId: MarkerId('from'), position: widget.fromLatLng))
      ..add(Marker(markerId: MarkerId('to'), position: widget.toLatLng))
      ..add(Marker(
          markerId: MarkerId('routelocation1'),
          position: widget.routelocation1))
      ..add(Marker(
          markerId: MarkerId('routelocation2'),
          position: widget.routelocation2));

    _createPolylines();
    // Listen for changes in the locations for the current route
    _firebaseSubscription = databaseReference
        .child('locations/${widget.routeId}')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        var busesData = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<LatLng> driverLocations = []; // List to store all driver locations
        List<String> busName = [];
        List<int> seatCount = []; // List to store all bus IDs
        busesData.forEach((String busId, dynamic busData) {
          if (busData != null && busData is Map<dynamic, dynamic>) {
            Map<String, dynamic> usersData = Map<String, dynamic>.from(busData);
            usersData.forEach((String uid, dynamic userData) {
              if (userData != null && userData is Map<dynamic, dynamic>) {
                var locationData = Map<String, dynamic>.from(userData);
                driverLocations.add(LatLng(
                    locationData['latitude'],
                    locationData[
                        'longitude'])); // Add each driver location to the list
                busName.add(locationData['busName']);
                seatCount.add(
                    locationData['seatCount']); // Add each bus ID to the list
              }
            });
          }
        });
        setState(() {
          _driverLocations =
              driverLocations; // Update _driverLocations with the new list
          _busName = busName;
          _seatCount = seatCount; // Update _busIds with the new list

          _updateMarkers(); // Update the markers set with the new driverLocations and busIds
        });
      } else {
        setState(() {
          _driverLocations = []; // Clear the list of driver locations
          _busName = [];
          _seatCount = []; // Clear the list of bus IDs

          _updateMarkers(); // Update the markers set without the driverLocations and busIds
        });
      }
    });
  }

  @override
  void dispose() {
    _firebaseSubscription?.cancel(); // Cancel the subscription
    super.dispose();
  }

  Future<void> _updateMarkers() async {
    _markers.clear();
    _markers
      ..add(Marker(markerId: MarkerId('from'), position: widget.fromLatLng))
      ..add(Marker(markerId: MarkerId('to'), position: widget.toLatLng))
      ..add(Marker(
          markerId: MarkerId('routelocation1'),
          position: widget.routelocation1))
      ..add(Marker(
          markerId: MarkerId('routelocation2'),
          position: widget.routelocation2));

    // Load custom bus icon as bytes
    ByteData data = await rootBundle.load('assets/buslocation.png');
    Uint8List byteList = data.buffer.asUint8List();
    // Add a marker for each driver location
    for (int i = 0; i < _driverLocations.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('driverLocation$i'),
        position: _driverLocations[i],
        icon: BitmapDescriptor.fromBytes(byteList),
        infoWindow: InfoWindow(
            title: '${_busName[i]} Waiting For You'), // Use the bus ID here
      ));
    }
  }

//000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  Future<void> _createPolylines() async {
    await _getDirectionsForHardcodedPolyline();
    await _getDirections();
  }

  Future<void> _getDirections() async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${widget.fromLatLng.latitude},${widget.fromLatLng.longitude}&'
        'destination=${widget.toLatLng.latitude},${widget.toLatLng.longitude}&'
        'mode=transit&'
        'transit_mode=bus&'
        'alternatives=true&'
        'key='; // Replace YOUR_API_KEY with your actual API key

    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);

    print('Directions API Response: $values');

    if (values['routes'].isNotEmpty) {
      List<dynamic> routes = values['routes'];
      _showRouteOptions(routes);
      String polylinePoints = routes[0]['overview_polyline']['points'];
      List<LatLng> polylineCoordinates =
          _convertToLatLng(_decodePolyline(polylinePoints));

      setState(() {
        // Add the blue polyline
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('selectedRoute'),
            visible: true,
            points: polylineCoordinates,
            color: Colors.blue,
          ),
        );
      });
    }
  }

  Future<void> _getDirectionsForHardcodedPolyline() async {
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${widget.routelocation1.latitude},${widget.routelocation1.longitude}&'
        'destination=${widget.routelocation2.latitude},${widget.routelocation2.longitude}&'
        'mode=transit&'
        'transit_mode=bus&'
        'alternatives=true&'
        'key='; // Replace YOUR_API_KEY with your actual API key

    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);

    print('Directions API Response for Hardcoded Polyline: $values');

    if (values['routes'].isNotEmpty) {
      List<dynamic> routes = values['routes'];
      String polylinePointsblack = routes[0]['overview_polyline']['points'];
      List<LatLng> polylineCoordinatesBlack =
          _convertToLatLng(_decodePolyline(polylinePointsblack));

      setState(() {
        // Add the black polyline
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('hardcodedPolyline'),
            visible: true,
            points: polylineCoordinatesBlack,
            color: Colors.black,
          ),
        );
      });
    }
  }

  void _showRouteOptions(List<dynamic> routes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose a Route'),
          content: Column(
            children: <Widget>[
              for (int i = 0; i < routes.length; i++)
                ListTile(
                  title: Text('Route ${i + 1}'),
                  subtitle: Text(
                    'Duration: ${routes[i]['legs'][0]['duration']['text']}, '
                    'Distance: ${routes[i]['legs'][0]['distance']['text']}',
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _displayChosenRoute(routes[i]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _displayChosenRoute(dynamic chosenRoute) {
    String polylinePoints = chosenRoute['overview_polyline']['points'];
    List<LatLng> polylineCoordinates =
        _convertToLatLng(_decodePolyline(polylinePoints));

    setState(() {
      // Add the blue polyline
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('selectedRoute'),
          visible: true,
          points: polylineCoordinates,
          color: Colors.blue,
        ),
      );
    });
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePolyline(String polyline) {
    var list = polyline.codeUnits;
    var lList = [];
    int index = 0;
    int len = polyline.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);

      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) {
      lList[i] += lList[i - 2];
    }

    return lList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enjoy Your Journy')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.fromLatLng,
          zoom: 15,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true, // Enable the "My Location" button
        myLocationButtonEnabled: true, // Enable the "My Location" layer
        onMapCreated: (GoogleMapController controller) {
          // Optional
        },
      ),
    );
  }
}
