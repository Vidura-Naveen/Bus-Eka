import 'package:flutter/material.dart';
// import 'package:bus_eka/screens/passenger/sharelocationorbook.dart';
// import 'package:bus_eka/screens/register_screen.dart';
import 'package:bus_eka/screens/map_part/map_or_timetable.dart';
import 'package:bus_eka/widgets/bluebutton.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/wrapper.dart';
import '../../models/user.dart' as user_model;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthMethodes _authMethodes = AuthMethodes();

  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Load the current user details
  void _loadCurrentUser() async {
    try {
      user_model.User? user = await _authMethodes.getCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // For the top space
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),

                  // Image for logo
                  Image.asset(
                    'assets/buseka.png',
                    height: 220,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // Text field for email
                  BlueBtn(
                    text: 'Bus Information',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapOrTimeTable(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 50,
                  ),

                  const Text(
                    "For Booking & Share Location",
                    style: TextStyle(
                      color: mainBlackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'outfit',
                    ),
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  BlueBtn(
                    text: 'My Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthWrapper(),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  // Remove padding around images using Container
                  Center(
                    child: Container(
                      padding: EdgeInsets.zero,
                      child: const Column(
                        children: [
                          Text(
                            "Discover Sri Lanka's leading",
                            style: TextStyle(
                              color: mainBlueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'outfit',
                            ),
                          ),
                          Text(
                            "Tracking and Booking platform",
                            style: TextStyle(
                              color: mainBlueColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'outfit',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Seamless travel anytime, anywhere & easy.",
                            style: TextStyle(
                              color: mainBlueColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
