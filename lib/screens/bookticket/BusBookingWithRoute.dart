import 'package:bus_eka_test/screens/bookticket/seat/booking_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/bookticket/book_bus_model.dart';
import 'package:bus_eka_test/screens/menu_item/drawer.dart';
import 'package:bus_eka_test/services/auth_logic.dart';
import 'package:bus_eka_test/utils/colors.dart';
import '../../models/user.dart' as user_model;

class BusBookingWithRoute extends StatefulWidget {
  final String routeId;
  final String routeName;
  final double ticketPrice;
  final DateTime selectedDate;
  // final String routeName;

  const BusBookingWithRoute(
      {Key? key,
      required this.routeId,
      required this.routeName,
      required this.ticketPrice,
      required this.selectedDate})
      : super(key: key);

  @override
  _BusBookingWithRouteState createState() => _BusBookingWithRouteState();
}

class _BusBookingWithRouteState extends State<BusBookingWithRoute> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser;
  late Stream<List<BusBook>> busesStream;
  // late Stream<List<BookRoutez>> routesStream;
  final FirebaseFirestore _firestoreBookTicketBus = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    busesStream = getBussesForRoute(widget.routeId);
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

  Stream<List<BusBook>> getBussesForRoute(String routeId) {
    return _firestoreBookTicketBus
        .collection('buscolection')
        .where('route', isEqualTo: routeId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BusBook.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: mainWhiteColor),
      ),
      drawer: AppDrawer(
        onSignOut: _signOut,
        userName: currentUser?.userName,
      ),
      body: SafeArea(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hey, ${currentUser?.userName ?? "Loading"}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: mainYellowColor,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
              const Text(
                'You Choose', // Replace with the actual variable containing the route name
                style: TextStyle(
                  color: mainWhiteColor,
                  fontSize: 16,
                ),
              ),
              Text(
                'Route: ${widget.routeName}', // Replace with the actual variable containing the route name
                style: const TextStyle(
                  color: mainWhiteColor,
                  fontSize: 16,
                ),
              ),
              Text(
                // ignore: unnecessary_null_comparison
                'Selected Date: ${widget.selectedDate != null ? widget.selectedDate.toLocal().toString().split(' ')[0] : 'Select Date'}',
                style: const TextStyle(
                  color: mainWhiteColor,
                  fontSize: 16,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              //ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
              StreamBuilder<List<BusBook>>(
                stream: busesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  List<BusBook> buses = snapshot.data!;

                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: buses.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: mainWhiteColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        'Bus Name: ${buses[index].busname}',
                                        style: TextStyle(color: mainBlueColor),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Start Time: ${buses[index].starttime}',
                                            style:
                                                TextStyle(color: mainBlueColor),
                                          ),
                                          Text(
                                            'Arrival Time: ${buses[index].endtime}',
                                            style:
                                                TextStyle(color: mainBlueColor),
                                          ),
                                          Text(
                                            'Price : LKR ${widget.ticketPrice}0',
                                            style:
                                                TextStyle(color: mainBlueColor),
                                          ),
                                          Text(
                                            'Seat Count : ${buses[index].seatcount}',
                                            style:
                                                TextStyle(color: mainBlueColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: mainGreenColor,
                                      // fixedSize: const Size(
                                      //     80, 50), // Set the width and height
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // Set the border radius
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BookingPage(
                                            userName: currentUser?.userName ??
                                                "Loading",
                                            busName: buses[index].busname,
                                            ticketPrice: widget.ticketPrice,
                                            seatCount: buses[index].seatcount,
                                            busId: buses[index].busid,
                                            routeId: widget.routeId,
                                            routeName: widget.routeName,
                                            selectedDate: widget.selectedDate,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Book',
                                      style: TextStyle(color: mainWhiteColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
