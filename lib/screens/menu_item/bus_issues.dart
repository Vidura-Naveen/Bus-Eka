import 'package:bus_eka/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/screens/menu_item/drawer.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import '../../models/user.dart' as user_model;
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'dart:async';

class BusIssue extends StatefulWidget {
  const BusIssue({Key? key}) : super(key: key);

  @override
  _BusIssueState createState() => _BusIssueState();
}

class _BusIssueState extends State<BusIssue> {
  final AuthMethodes _authMethodes = AuthMethodes();
  user_model.User? currentUser;
  final TextEditingController _issueTextController =
      TextEditingController(); // Controller for the text area

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
      // ignore: avoid_print
      print("Error loading current user: $e");
    }
  }

  void _submitIssue() async {
    try {
      String userId = currentUser?.uid ?? '';
      String userName = currentUser?.userName ?? '';
      String issueText = _issueTextController.text;

      if (issueText.isNotEmpty) {
        // Save to Firebase database
        await FirebaseService.saveIssueToDatabase(userId, userName, issueText);

        // Clear the text area after submission
        _issueTextController.clear();
        // Show SnackBar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'We Have received your concern and are actively addressing it. Thank you for bringing it to our attention.'),
            duration: Duration(seconds: 4), // Optional: Set the duration
          ),
        );
      } else {
        // Show SnackBar for empty issue text
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter an issue before submitting'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error submitting issue: $e");
      // Handle the error (e.g., show an error message)
    }
  }

  @override
  void dispose() {
    _issueTextController.dispose();
    super.dispose();
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
                  'Submit Any Issue',
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    const Text(
                      'Tell us if you have problems with the bus, routes, or anything else, and we will fix it quickly',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: mainBlueColor,
                        fontSize: 16,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _issueTextController,
                      maxLines: 5,
                      onChanged: (value) {
                        // Handle text area changes
                        // You can store the value in a variable in the state
                      },
                      style: const TextStyle(
                          color: mainBlueColor), // Set text color to blue
                      decoration: InputDecoration(
                        labelText: 'Please submit your issue clearly',
                        labelStyle: const TextStyle(
                          color: mainBlueColor,
                        ), // Set label color to blue
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: mainBlueColor,
                          ), // Set border color to blue
                          borderRadius:
                              BorderRadius.circular(10.0), // Set border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color:
                                  mainBlueColor), // Set focused border color to blue
                          borderRadius: BorderRadius.circular(
                              10.0), // Set focused border radius
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
                        _submitIssue();
                      },
                      child: const Text(
                        'Submit Issue',
                        style: TextStyle(color: mainWhiteColor),
                      ),
                    ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.1,
                    // ),
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
      );
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
    }
  }
}

class FirebaseService {
  static final CollectionReference _issueCollection =
      FirebaseFirestore.instance.collection('issuecollection');

  static Future<void> saveIssueToDatabase(
      String userId, String userName, String issueText) async {
    try {
      await _issueCollection.add({
        'userId': userId,
        'userName': userName,
        'issueText': issueText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print("Error saving issue to database: $e");
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
