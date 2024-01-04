//reset seats
import 'package:bus_eka_test/screens/bookticket/payment_form.dart';
import 'package:bus_eka_test/screens/bookticket/seat/reset_seats.dart';
import 'package:bus_eka_test/utils/colors.dart';
//reset seats

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'ticket.dart';

class BookingPage extends StatefulWidget {
  final String userName;
  final String busName;
  final double ticketPrice;
  final String busId;
  final int seatCount;
  final String routeId;
  final String routeName;
  final DateTime selectedDate;

  BookingPage(
      {required this.userName,
      required this.busName,
      required this.ticketPrice,
      required this.busId,
      required this.seatCount,
      required this.routeId,
      required this.routeName,
      required this.selectedDate});
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  late int seatCount;
  late List<bool> seatStatus;

  //reset seats
  final SeatResetService _seatResetService = SeatResetService();
  //reset seats
  List<int> newlyBookedSeats = [];
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _seatCollection =
      FirebaseFirestore.instance.collection('seatCollection');

  // List<bool> seatStatus = List.generate(15, (index) => false);

  Future<List<bool>> getSeatStatusFromFirebase() async {
    //oooooooooooooooooooooooooooooooooooooooooooooooooooooooo
    DocumentSnapshot document = await _seatCollection
        .doc('${widget.selectedDate}${widget.busId}${widget.routeId}')
        .get();

    if (document.exists) {
      // If the document exists, return the seatStatus list
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      // ignore: unnecessary_null_comparison
      if (data != null && data.containsKey('seatStatus')) {
        List<dynamic> seatStatusData = data['seatStatus'];
        return seatStatusData.map((status) => status as bool).toList();
      }
    }

    // If the document doesn't exist or doesn't contain the seatStatus field, return a default list
    return List.generate(widget.seatCount, (index) => false);
  }

  Future<void> createSeatDocument() async {
    DocumentSnapshot document = await _seatCollection
        .doc('${widget.selectedDate}${widget.busId}${widget.routeId}')
        .get();

    if (!document.exists) {
      // Create the document if it doesn't exist
      await _seatCollection
          .doc('${widget.selectedDate}${widget.busId}${widget.routeId}')
          .set({
        'seatStatus': List.generate(widget.seatCount, (index) => false),
      });
    }
  }

  Future<void> updateSeatStatus(int index, bool booked) async {
    // Ensure the document exists before updating
    await createSeatDocument();

    // Update the seat status
    DocumentReference docRef = _seatCollection
        .doc('${widget.selectedDate}${widget.busId}${widget.routeId}');
    Map<String, dynamic> data =
        (await docRef.get()).data() as Map<String, dynamic>;

    // ignore: unnecessary_null_comparison
    if (data != null && data.containsKey('seatStatus')) {
      List<bool> updatedStatus = List.from(data['seatStatus']);
      updatedStatus[index] = booked;

      await docRef.update({'seatStatus': updatedStatus});
    }
  }

  @override
  void initState() {
    super.initState();
    seatCount = widget.seatCount;
    seatStatus = List.generate(seatCount, (index) => false);
    // Fetch seat status from Firebase during initialization
    getSeatStatusFromFirebase().then((seatStatusFromFirebase) {
      setState(() {
        seatStatus = seatStatusFromFirebase;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Booking'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'User: ${widget.userName}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Bus Name: ${widget.busName}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Ticket Price: LKR ${widget.ticketPrice}0',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Seat Count: ${widget.seatCount}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Route : ${widget.routeName}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                // ignore: unnecessary_null_comparison
                'Selected Date: ${widget.selectedDate != null ? widget.selectedDate.toLocal().toString().split(' ')[0] : 'Select Date'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.seatCount,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () async {
                    if (!seatStatus[index]) {
                      setState(() {
                        seatStatus[index] = !seatStatus[index];
                        if (!newlyBookedSeats.contains(index)) {
                          newlyBookedSeats.add(index);
                        }
                      });
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: seatStatus[index]
                          ? const Color.fromARGB(255, 255, 0, 0)
                          : mainGreenColor,
                      border: Border.all(),
                    ),
                    child: Center(
                      child: Text(
                        seatStatus[index] ? 'Booked' : 'Seat $index',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              seatStatus[index] ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  List<int> bookedSeats = seatStatus
                      .asMap()
                      .entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  // Update Firestore with booked seat information
                  for (int index in bookedSeats) {
                    await updateSeatStatus(index, true);
                  }

                  // Pass the newly booked seats to ConfirmationPage
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentForm(
                        newlyBookedSeats: newlyBookedSeats,
                        routeName: widget.routeName,
                        ticketPrice: widget.ticketPrice,
                        busName: widget.busName,
                        busId: widget.busId,
                        routeId: widget.routeId,
                        selectedDate: widget.selectedDate,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Submit Booking',
                  style: TextStyle(color: mainWhiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlueColor,
                  fixedSize: const Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () async {
              //     // Reset all seats
              //     await _seatResetService.resetAllSeats(
              //       widget.busId,
              //       widget.routeId,
              //       widget.seatCount,
              //       widget.selectedDate,
              //     );
              //   },
              //   child: Text('Reset All Seats'),
              // ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
