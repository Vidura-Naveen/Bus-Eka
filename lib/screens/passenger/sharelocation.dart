import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bus_eka/screens/menu_item/drawer.dart';
// import 'package:bus_eka/screens/passenger/route_model_for_locationshare.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
// import 'package:bus_eka/widgets/text_feild.dart';
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
  final int seatcount;

  BusData({
    required this.busid,
    required this.busname,
    required this.route,
    required this.seatcount,
  });
}

class ShareLocation extends StatefulWidget {
  const ShareLocation({Key? key}) : super(key: key);

  @override
  _ShareLocationState createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  final databaseReference = FirebaseDatabase.instance.ref();
  bool isSharingLocation = false;
  bool shouldUpdateLocation = true;
  final AuthMethodes _authMethodes = AuthMethodes();
  // TextEditingController busController = TextEditingController();
  user_model.User? currentUser;

  List<RouteData> routeNames = [];
  List<BusData> busNames = [];
  List<BusData> seatCount = [];
  RouteData? selectedRoute;
  BusData? selectedBus;

  bool isDropdownEnabled = true;
  bool isBusDropdownEnabled = true;

  // Fetch route data from Firebase
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
    loadBusNames();
  }

  // Fetch bus data based on the selected route
  void loadBusNames() async {
    if (selectedRoute != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('buscolection')
          .where('route', isEqualTo: selectedRoute!.routeId)
          .get();

      setState(() {
        busNames = querySnapshot.docs
            .map((doc) => BusData(
                  busid: doc.id,
                  busname: doc['busname'] as String,
                  seatcount: doc['seatcount'] as int,
                  route: doc['route'] as String,
                ))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    loadRouteNames();
  }

  @override
  void dispose() {
    // Add code to stop location updates or reset variables.
    shouldUpdateLocation =
        false; // Ensure the loop stops when the widget is disposed.
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        onSignOut: _signOut,
        userName: currentUser?.userName,
      ),
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
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Share Your Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
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
                    children: [
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                      // DropdownButton to display route options
                      DropdownButton<RouteData>(
                        value: selectedRoute,
                        items: routeNames.map((RouteData route) {
                          return DropdownMenuItem<RouteData>(
                            value: route,
                            child: Text(route.routeName),
                          );
                        }).toList(),
                        onChanged: isDropdownEnabled
                            ? (RouteData? value) {
                                setState(() {
                                  selectedRoute = value;
                                  selectedBus = null;
                                });
                                // Load bus names based on the selected route
                                loadBusNames();
                              }
                            : null,
                        hint: Text('Select Route'),
                        disabledHint: Text('Select Route (Disabled)'),
                      ),

                      //00000000000000000000000000000000000000000000000000000000000
                      // DropdownButton to display bus options
                      DropdownButton<BusData>(
                        value: selectedBus,
                        items: busNames.map((BusData bus) {
                          return DropdownMenuItem<BusData>(
                            value: bus,
                            child: Text(bus.busname),
                          );
                        }).toList(),
                        onChanged: isBusDropdownEnabled
                            ? (BusData? value) {
                                setState(() {
                                  selectedBus = value;
                                });
                              }
                            : null,
                        hint: Text('Select Bus'),
                        disabledHint: Text('Select Bus (Disabled)'),
                      ),

                      const SizedBox(height: 50),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: startSharingLocation,
                        child: Text('Start Sharing Location'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: stopSharingLocation,
                        child: Text('Stop Sharing Location'),
                      ),
                      const SizedBox(height: 5),
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

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//startSharing location
  void startSharingLocation() async {
    if (selectedRoute == null || selectedBus == null) {
      // Show a banner message indicating that both route and bus need to be selected.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please select both route and bus to start sharing location.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showPopup('Location permission denied.');
        return;
      }
    }

    setState(() {
      isSharingLocation = true;
      isDropdownEnabled = false;
      isBusDropdownEnabled = false;
    });
    shouldUpdateLocation = true;
    updateLocation();
    _showPopup('Sharing location started.');
  }

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//Update location
  void updateLocation() async {
    while (isSharingLocation && shouldUpdateLocation) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Check if isSharingLocation is still true after getting the position
        if (!isSharingLocation) {
          return;
        }

        String uid = currentUser?.uid ?? ""; // Get the user's UID
        if (uid.isNotEmpty && selectedRoute != null && selectedBus != null) {
          String routeId = selectedRoute!.routeId;
          String busId = selectedBus!.busid;
          String busName = selectedBus!.busname;
          int seatcount = selectedBus!.seatcount;
          // Update the Firebase Realtime Database with the current location.
          databaseReference.child('locations/$routeId/$busId/$uid').set({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'busId': busId,
            'busName': busName,
            'seatCount': seatcount,
          });
        }

        // Simulate continuous updates by adding a delay
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        // Handle the exception
        print('Error getting location: $e');
      }
    }
  }

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//Stop location
  void stopSharingLocation() {
    setState(() {
      isSharingLocation = false;
      isDropdownEnabled = true;
      isBusDropdownEnabled = true;
    });

    String uid = currentUser?.uid ?? "";
    if (uid.isNotEmpty) {
      // Iterate over all routes
      databaseReference
          .child('locations')
          .once()
          .then((DatabaseEvent routesEvent) {
        final dynamic snapshotValue = routesEvent.snapshot.value;

        if (snapshotValue != null && snapshotValue is Map<dynamic, dynamic>) {
          // ignore: unnecessary_nullable_for_final_variable_declarations
          final Map<String, dynamic>? routes =
              Map<String, dynamic>.from(snapshotValue);

          if (routes != null) {
            routes.forEach((String routeId, dynamic routeData) {
              if (routeData != null && routeData is Map<dynamic, dynamic>) {
                // Iterate over all buses for each route
                Map<String, dynamic> busData =
                    Map<String, dynamic>.from(routeData);

                busData.forEach((String busId, dynamic data) {
                  if (data != null && data is Map<dynamic, dynamic>) {
                    // Check if the user's UID exists for this route and bus
                    if (data.containsKey(uid)) {
                      // Set the location for the specific user to null
                      databaseReference
                          .child('locations/$routeId/$busId/$uid')
                          .set(null);
                    }
                  }
                });
              }
            });
          }
        }
      });
    }

    // Display the popup
    _showPopup('Sharing location stopped.');
    setState(() {
      isSharingLocation = false;
      isDropdownEnabled = true;
      isBusDropdownEnabled = true;
    });
    shouldUpdateLocation = false;
  }

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//Show Popup
  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Sharing"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

//ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
//Sign out
  void _signOut() async {
    try {
      await _authMethodes.signOut();
      setState(() {
        currentUser = null;
      });
      Navigator.pop(context);
    } catch (err) {
      print(err.toString());
    }
  }
}
