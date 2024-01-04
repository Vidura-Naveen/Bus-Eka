import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/firebase_options.dart';
import 'package:bus_eka/screens/home.dart';
import 'package:bus_eka/utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: mainWhiteColor),
      debugShowCheckedModeBanner: false,
      title: "Bus eka",
      home: const Home(),

      // home: ReceiptForm(),
    );
  }
}
