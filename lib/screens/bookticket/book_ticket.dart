import 'package:bus_eka_test/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka_test/screens/bookticket/BusBookingWithRoute.dart';
import 'package:bus_eka_test/screens/menu_item/drawer.dart';
import 'package:bus_eka_test/services/auth_logic.dart';
import 'package:bus_eka_test/utils/colors.dart';
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
  _BookTicketState createState() => _BookTicketState();
}

class _BookTicketState extends State<BookTicket> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser;
  List<RouteData> routeNames = [];
  RouteData? selectedRoute;
  DateTime? selectedDate;

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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Hey, ${currentUser?.userName ?? "Loading"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 22,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Book Your Ticket',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mainWhiteColor,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/man.png',
                    height: 80,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Select Route You Want',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mainBlueColor,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      const SizedBox(height: 50),
                      DropdownButtonFormField<RouteData>(
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
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Select Route',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainGreenColor,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          // Show date picker
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 3)),
                          );

                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: mainWhiteColor,
                              ),
                              Text(
                                'Selected Date: ${selectedDate != null ? selectedDate!.toLocal().toString().split(' ')[0] : 'Pick Date Here'}',
                                style: TextStyle(color: mainWhiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlueColor,
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Book Bus',
                          style: TextStyle(color: mainWhiteColor),
                        ),
                        onPressed: () async {
                          try {
                            if (selectedRoute == null || selectedDate == null) {
                              throw Exception('Please select a route and date');
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusBookingWithRoute(
                                  routeId: selectedRoute!.routeId,
                                  routeName: selectedRoute!.routeName,
                                  ticketPrice: selectedRoute!.ticketPrice,
                                  selectedDate: selectedDate!,
                                ),
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

      setState(() {
        currentUser = null;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } catch (err) {
      print(err.toString());
    }
  }
}
