import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String res) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(res),
    ),
  );
}
