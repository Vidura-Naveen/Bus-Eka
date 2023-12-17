import 'package:flutter/material.dart';

import '../utils/colors.dart';

class YellowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const YellowButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          color: mainYellowColor,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: const ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(Colors.black),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
