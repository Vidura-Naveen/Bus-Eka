import 'package:flutter/material.dart';

import '../utils/colors.dart';

class BlueBtn extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const BlueBtn({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          color: mainBlueColor,
        ),
        child: TextButton(
          onPressed: onPressed,
          style: const ButtonStyle(
            foregroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
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
