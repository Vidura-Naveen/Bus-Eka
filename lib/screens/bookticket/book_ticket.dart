import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/screens/bookticket/BusBookingWithRoute.dart';
import 'package:bus_eka/screens/menu_item/drawer.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import '../../models/user.dart' as user_model;

class RouteData {
  final String routeId;
  final String routeName;
  final double ticketPrice;

  RouteData({
    required this.routeId,
    required this.routeName,
    required this.ticketPrice,
  });
}

class BookTicket extends StatefulWidget {
  const BookTicket({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookTicketState createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser; // Use nullable type
  List<RouteData> routeNames = [];
  RouteData? selectedRoute;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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
                ticketPrice: doc['ticketprice'] as double,
              ))
          .toList();
    });
  }

  // Load the current user details
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
        onSignOut: _signOut, // Pass the sign-out callback
        userName: currentUser?.userName, // Pass the current user's name
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
                  'Hay, ${currentUser?.userName ?? "Loading"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 20, // Set the font size to 20
                    fontFamily:
                        'Montserrat', // Replace 'RobotoMono' with the actual font family name
                  ),
                ),

                const SizedBox(height: 5),
                const Text(
                  'Book Your Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/man.png',
                    height: 80,
                  ),
                ),
                // Container with buttons
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
                      const Text(
                        'Selecet Route You want',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mainBlueColor,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      const SizedBox(height: 50),
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
                          // loadRouteData();
                        },
                        hint: Text('Select Route'),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        child: Text('Book Bus'),
                        onPressed: () async {
                          try {
                            if (selectedRoute == null) {
                              throw Exception('Please select a route');
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusBookingWithRoute(
                                    routeId: selectedRoute!.routeId,
                                    routeName: selectedRoute!.routeName,
                                    ticketPrice: selectedRoute!.ticketPrice),
                              ),
                            );
                          } catch (e) {
                            // ... (error handling)
                          }
                        },
                      ),
                      const SizedBox(height: 10),
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

      // Update the currentUser state after signing out
      setState(() {
        currentUser = null;
      });

      Navigator.pop(context); // Close the current screen after sign-out
    } catch (err) {
      print(err.toString());
    }
  }
}
