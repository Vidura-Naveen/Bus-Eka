import 'package:flutter/material.dart';


class ReceiptForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow('User Name', 'John Doe'),
            _buildInfoRow('Bus Route', 'Route ABC'),
            _buildInfoRow('Bus Name', 'Awesome Bus'),
            _buildInfoRow('Seat Number', 'A12'),
            _buildInfoRow('Price', '\$25.00'),
            _buildInfoRow('Time and Date', '12 Dec 2023, 10:30 AM'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
