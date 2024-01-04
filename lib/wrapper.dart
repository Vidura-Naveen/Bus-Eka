import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/passenger/passenger_options.dart';
import 'package:bus_eka_test/screens/register_screen.dart';
// import 'package:bus_eka_test/screens/home.dart';
import 'package:bus_eka_test/services/auth_logic.dart';
import 'package:bus_eka_test/utils/colors.dart';

// ooooooooooooooooooooooo Dont use const ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
class AuthWrapper extends StatelessWidget {
  final AuthMethodes authMethodes = AuthMethodes();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authMethodes.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            // User is authenticated
            return PassengerOption();
          } else {
            // User is not authenticated or current user is null
            return RegisterScreen();
          }
        } else if (snapshot.hasError) {
          // Handle the error, for example, show an error message
          return Text("Error: ${snapshot.error}");
        } else {
          // Loading state, return a loading indicator if needed
          return CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(mainBlueColor),
          );
        }
      },
    );
  }
}
