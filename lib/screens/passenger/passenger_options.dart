import 'package:bus_eka_test/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/bookticket/book_ticket.dart';
import 'package:bus_eka_test/screens/menu_item/drawer.dart';
import 'package:bus_eka_test/screens/passenger/sharelocation.dart';
import 'package:bus_eka_test/screens/map_part/map_or_timetable.dart';
import 'package:bus_eka_test/services/auth_logic.dart';
import 'package:bus_eka_test/utils/colors.dart';
import 'package:bus_eka_test/widgets/bluebutton.dart';
import 'package:bus_eka_test/widgets/greenbutton.dart';
import 'package:bus_eka_test/widgets/yellowbutton.dart';
import '../../models/user.dart' as user_model;

class PassengerOption extends StatefulWidget {
  const PassengerOption({Key? key}) : super(key: key);

  @override
  _PassengerOptionState createState() => _PassengerOptionState();
}

class _PassengerOptionState extends State<PassengerOption> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        onSignOut: _signOut,
        userName: currentUser?.userName,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  'Hay, ${currentUser?.userName ?? "Loading"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: mainYellowColor,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'What do you want to DO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: mainWhiteColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/man.png',
                    height: 80,
                  ),
                ),

                // Container with buttons
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GreenButton(
                        text: 'Bus Information',
                        onPressed: () => _navigateTo(MapOrTimeTable()),
                      ),
                      const SizedBox(height: 30),
                      YellowButton(
                        text: 'Bus Booking',
                        onPressed: () => _navigateTo(BookTicket()),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mainBlueColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlueBtn(
                        text: 'Share Your Location',
                        onPressed: () => _navigateTo(ShareLocation()),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/locationicon.png',
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _signOut() async {
    try {
      await _authMethodes.signOut();
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
