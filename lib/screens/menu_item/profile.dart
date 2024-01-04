import 'package:bus_eka_test/screens/home.dart';
import 'package:bus_eka_test/screens/passenger/passenger_options.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/menu_item/drawer.dart';
import 'package:bus_eka_test/services/auth_logic.dart';
import 'package:bus_eka_test/utils/colors.dart';
import '../../models/user.dart' as user_model;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser; // Use nullable type

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainWhiteColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        onSignOut: _signOut,
        userName: currentUser?.userName,
      ),
      body: Column(
        children: [
          // Blue Part
          Container(
            width: double.infinity,
            color: mainBlueColor,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hay, ${currentUser?.userName ?? "User"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/man.png',
                    height: 70,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mainWhiteColor,
                    fontSize: 25,
                    fontFamily: 'RobotoMono',
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // White Part
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Your Name',
                      style: TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: currentUser?.userName ?? "No User",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: mainBlueColor,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Your Email',
                      style: TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: currentUser?.email ?? " No User",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: mainBlueColor,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Your Loyality count',
                      style: TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '${currentUser?.loyaltycount ?? " No User"}',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: mainBlueColor,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Your Mobile Number',
                      style: TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    TextField(
                      enabled: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: currentUser?.phoneno ?? " No User",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: mainBlueColor,
                        filled: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainGreenColor,
                        fixedSize:
                            const Size(300, 50), // Set the width and height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Set the border radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PassengerOption(),
                          ),
                        );
                      },
                      child: Text(
                        'Back To Home',
                        style: TextStyle(color: mainWhiteColor),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    try {
      await _authMethodes.signOut();

      // Update the currentUser state after signing out
      setState(() {
        currentUser = null;
      });

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => AdminOption(),
          builder: (context) => const Home(),
        ),
      ); // Close the current screen after sign-out
    } catch (err) {
      print(err.toString());
    }
  }
}
