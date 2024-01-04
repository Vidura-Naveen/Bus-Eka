import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bus_eka/screens/map_part/map_or_timetable.dart';
import 'package:bus_eka/widgets/bluebutton.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/wrapper.dart';
import '../../models/user.dart' as user_model;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _requestNotificationPermission();
  }

  void _loadCurrentUser() async {
    try {
      user_model.User? user = await _authMethodes.getCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
    }
  }

  void _requestNotificationPermission() async {
    var status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission is granted
      print("Notification permission granted");
    } else if (status.isDenied) {
      // Permission is denied
      print("Notification permission denied");
      _showPermissionBanner();
    }
  }

  void _showPermissionBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please allow notifications to receive updates."),
        action: SnackBarAction(
          label: "Allow",
          onPressed: () {
            // Open app settings to allow notifications
            openAppSettings();
          },
        ),
      ),
    );
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Image.asset(
                    'assets/buseka.png',
                    height: 220,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
