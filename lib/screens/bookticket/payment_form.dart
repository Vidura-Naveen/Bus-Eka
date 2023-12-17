import 'package:flutter/material.dart';

class PaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPaymentMethod(),
              _buildCardHolderName(),
              _buildCardNumber(),
              _buildExpiryDate(),
              _buildCVN(),
              _buildTotalAmount(),
              _buildButtons(),
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '\$100.00', // Replace with your actual amount
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0), // Adjust color as needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Implement cancel button action
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 229, 33)),
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Implement pay button action
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Pay'),
          ),
        ),
      ],
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
