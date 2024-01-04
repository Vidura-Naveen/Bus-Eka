import 'package:flutter/material.dart';
import 'package:bus_eka/utils/colors.dart';
// import 'package:bus_eka/utils/colors.dart';

class TextFeildInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputkeyboardType;
  final String hintText;

  const TextFeildInput({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.isPassword,
    required this.inputkeyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The styling for the text field
    final inputDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      fillColor: mainBlueColor,
      filled: true,
      contentPadding: const EdgeInsets.all(8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0), // Set border radius here
        borderSide: BorderSide.none,
      ),
    );

    return TextField(
      controller: controller,
      decoration: inputDecoration,
      keyboardType: inputkeyboardType,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
    );
  }
}
