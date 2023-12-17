import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/bus/bus_home.dart';
import 'package:bus_eka/screens/admin/passenger/passenger_home.dart';
import 'package:bus_eka/screens/admin/route/route_home.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/widgets/bluebutton.dart';
import 'package:bus_eka/widgets/greenbutton.dart';
import 'package:bus_eka/widgets/yellowbutton.dart';

class AdminOption extends StatefulWidget {
  const AdminOption({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminOptionState createState() => _AdminOptionState();
}

class _AdminOptionState extends State<AdminOption> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
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
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const Text(
                  'Hay, Admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20, // Set the font size to 20
                    fontFamily:
                        'Montserrat', // Replace 'RobotoMono' with the actual font family name
                  ),
                ),

                const SizedBox(height: 5),
                const Text(
                  'What You want to DO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
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
                        text: 'BUS',
                        onPressed: () {
                          // Add your logic for button 2 here
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BusCrud()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      YellowButton(
                        text: 'Route',
                        onPressed: () {
                          // Add your logic for button 2 here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RouteCrud()),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      BlueBtn(
                        text: 'Passenger',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassengerCrud()),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
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
}
