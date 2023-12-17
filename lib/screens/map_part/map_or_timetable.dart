import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:bus_eka/screens/drawer.dart';
import 'package:bus_eka/screens/map_part/map_page.dart';
import 'package:bus_eka/screens/map_part/timetable.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';

import '../../models/user.dart' as user_model;

class RouteData {
  final String routeId;
  final String routeName;

  RouteData({
    required this.routeId,
    required this.routeName,
  });
}

class BusData {
  final String busid;
  final String busname;
  final String route;

  BusData({
    required this.busid,
    required this.busname,
    required this.route,
  });
}

class MapOrTimeTable extends StatefulWidget {
  // ignore: use_super_parameters
  const MapOrTimeTable({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapOrTimeTableState createState() => _MapOrTimeTableState();
}

class _MapOrTimeTableState extends State<MapOrTimeTable> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  LatLng routelocation1 = LatLng(0.0, 0.0);
  LatLng routelocation2 = LatLng(0.0, 0.0);
  double fromLatitude = 0.0;
  double fromLongitude = 0.0;
  double toLatitude = 0.0;
  double toLongitude = 0.0;
  List<RouteData> routeNames = [];
  RouteData? selectedRoute; // Updated to use RouteData instead of String
  final AuthMethodes _authMethodes = AuthMethodes();
  TextEditingController temporaryController = TextEditingController();
  user_model.User? currentUser;

  // String? selectedRoute;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _requestLocationPermission();
    loadRouteNames();
  }

  void loadRouteNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('routcolection').get();

    setState(() {
      routeNames = querySnapshot.docs
          .map((doc) => RouteData(
                routeId: doc.id,
                routeName: doc['routename'] as String,
              ))
          .toList();
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Location Permission Required'),
            content:
                const Text('Please enable location services to use this app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _loadCurrentUser() async {
    try {
      user_model.User? user = await _authMethodes.getCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
    }
  }

  void loadRouteData() async {
    if (selectedRoute != null) {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection('routcolection')
              .doc(selectedRoute!.routeId)
              .get();

      if (documentSnapshot.exists) {
        var routeData = documentSnapshot.data();
        // ignore: unnecessary_type_check
        if (routeData != null && routeData is Map<String, dynamic>) {
          setState(() {
            fromLatitude = routeData['fromlatitude'] ?? 0.0;
            fromLongitude = routeData['fromlongitude'] ?? 0.0;
            toLatitude = routeData['tolatitude'] ?? 0.0;
            toLongitude = routeData['tolongitude'] ?? 0.0;

            routelocation1 = LatLng(fromLatitude, fromLongitude);
            routelocation2 = LatLng(toLatitude, toLongitude);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      // drawer: AppDrawer(
      //   onSignOut: _signOut,
      //   userName: currentUser?.userName,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Hay, ${currentUser?.userName ?? "User"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Where You want to GO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextField(
                        controller: _fromController,
                        decoration: const InputDecoration(labelText: 'From'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _toController,
                        decoration: const InputDecoration(labelText: 'To'),
                      ),
                      const SizedBox(height: 20),
                      DropdownButton<RouteData>(
                        value: selectedRoute,
                        items: routeNames.map((RouteData route) {
                          return DropdownMenuItem<RouteData>(
                            value: route,
                            child: Text(route.routeName),
                          );
                        }).toList(),
                        onChanged: (RouteData? value) {
                          setState(() {
                            selectedRoute = value;
                          });
                          loadRouteData();
                        },
                        hint: const Text('Select Route'),
                      ),
                      const SizedBox(height: 10),
                      //ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
                      ElevatedButton(
                        child: Text('Show Map'),
                        onPressed: () async {
                          if (_fromController.text.isEmpty ||
                              _toController.text.isEmpty ||
                              selectedRoute == null) {
                            // Show Snackbar for error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please fill in all fields (From, To, and Route)'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            try {
                              List<Location> fromLocations =
                                  await locationFromAddress(
                                      _fromController.text);
                              List<Location> toLocations =
                                  await locationFromAddress(_toController.text);

                              LatLng fromLatLng = LatLng(
                                  fromLocations[0].latitude,
                                  fromLocations[0].longitude);
                              LatLng toLatLng = LatLng(toLocations[0].latitude,
                                  toLocations[0].longitude);

                              Position currentPosition =
                                  await Geolocator.getCurrentPosition();
                              LatLng currentLatLng = LatLng(
                                  currentPosition.latitude,
                                  currentPosition.longitude);

                              // Navigate to the map page
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(
                                    fromLatLng: fromLatLng,
                                    toLatLng: toLatLng,
                                    routelocation1: routelocation1,
                                    routelocation2: routelocation2,
                                    currentLatLng: currentLatLng,
                                    routeId: selectedRoute!.routeId,
                                    routeName: selectedRoute!.routeName,
                                  ),
                                ),
                              );
                            } catch (e) {
                              // Handle other errors if needed
                              print('Error: $e');
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      //oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
                      ElevatedButton(
                        child: const Text('Show Timetable'),
                        onPressed: () async {
                          if (selectedRoute == null) {
                            // Show Snackbar for error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a route'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return; // Return from the function if validation fails
                          }

                          try {
                            List<Location> fromLocations =
                                await locationFromAddress(_fromController.text);
                            List<Location> toLocations =
                                await locationFromAddress(_toController.text);

                            LatLng fromLatLng = LatLng(
                                fromLocations[0].latitude,
                                fromLocations[0].longitude);
                            LatLng toLatLng = LatLng(toLocations[0].latitude,
                                toLocations[0].longitude);

                            Position currentPosition =
                                await Geolocator.getCurrentPosition();
                            LatLng currentLatLng = LatLng(
                                currentPosition.latitude,
                                currentPosition.longitude);

                            // Navigate to the timetable page
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimeTablePage(
                                  fromLatLng: fromLatLng,
                                  toLatLng: toLatLng,
                                  routelocation1: routelocation1,
                                  routelocation2: routelocation2,
                                  currentLatLng: currentLatLng,
                                  routeId: selectedRoute!.routeId,
                                ),
                              ),
                            );
                          } catch (e) {
                            // Handle other exceptions if needed
                            print('Error: $e');
                          }
                        },
                      ),
                      //ooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await _authMethodes.signOut();
      setState(() {
        currentUser = null;
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (err) {
      print(err.toString());
    }
  }
}
