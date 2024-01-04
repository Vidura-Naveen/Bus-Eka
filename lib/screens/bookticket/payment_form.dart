// ignore_for_file: unused_local_variable

import 'package:bus_eka_test/screens/bookticket/seat/ticket.dart';
import 'package:bus_eka_test/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentForm extends StatelessWidget {
  final List<int> newlyBookedSeats;
  final String routeName;
  final double ticketPrice;
  final String busName;
  final DateTime selectedDate;
  final String busId;
  final String routeId;
  final String userName;

  PaymentForm({
    required this.newlyBookedSeats,
    required this.routeName,
    required this.ticketPrice,
    required this.busName,
    required this.selectedDate,
    required this.routeId,
    required this.busId,
    required this.userName,
  });

  Future<void> _resetBookedSeats() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference _seatCollection =
        FirebaseFirestore.instance.collection('seatCollection');

    final seatDocId = '${selectedDate}${busId}${routeId}';

    // Fetch the current seatStatus from Firebase
    DocumentSnapshot document = await _seatCollection.doc(seatDocId).get();

    if (document.exists) {
      // If the document exists, update only the seats in newlyBookedSeats to false
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      // ignore: unnecessary_null_comparison
      if (data != null && data.containsKey('seatStatus')) {
        List<bool> seatStatus = List.from(data['seatStatus']);

        for (int index in newlyBookedSeats) {
          if (index >= 0 && index < seatStatus.length) {
            seatStatus[index] = false;
          }
        }

        // Update the seatStatus in Firebase
        await _seatCollection.doc(seatDocId).update({'seatStatus': seatStatus});
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _resetBookedSeats();
            Navigator.pop(context);
          },
        ),
        title: Text('Payment Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('You booked: ${newlyBookedSeats.join(' and ')} Seats',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Total: ${newlyBookedSeats.length * ticketPrice}0 LKR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              _buildPaymentMethod(),
              _buildCardHolderName(),
              _buildCardNumber(),
              _buildExpiryDate(),
              _buildCVN(),
              _buildTotalAmount(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _resetBookedSeats();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainYellowColor),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: mainBlackColor),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketPage(
                              newlyBookedSeats: newlyBookedSeats,
                              routeName: routeName,
                              ticketPrice: ticketPrice,
                              busName: busName,
                              selectedDate: selectedDate,
                              userName: userName,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: mainBlueColor),
                      child: Text(
                        'Pay',
                        style: TextStyle(color: mainWhiteColor),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            _buildCardType('Visa', Icons.credit_card),
            SizedBox(width: 16),
            _buildCardType('Mastercard', Icons.credit_card),
          ],
        ),
      ],
    );
  }

  Widget _buildCardType(String type, IconData icon) {
    return Row(
      children: [
        Radio(value: type, groupValue: null, onChanged: (value) {}),
        Icon(icon),
        Text(type),
      ],
    );
  }

  Widget _buildCardHolderName() {
    return _buildTextField('Card Holder Name');
  }

  Widget _buildCardNumber() {
    return _buildTextField('Card Number');
  }

  Widget _buildExpiryDate() {
    return Row(
      children: [
        Expanded(child: _buildTextField('Expiration Month')),
        SizedBox(width: 16),
        Expanded(child: _buildTextField('Expiration Year')),
      ],
    );
  }

  Widget _buildCVN() {
    return _buildTextField('CVN');
  }

  Widget _buildTotalAmount() {
    double totalAmount = newlyBookedSeats.length * ticketPrice;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Total: RS.${totalAmount.toStringAsFixed(2)}', // Format to two decimal places
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0), // Adjust color as needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
