import 'package:bus_eka/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/screens/home.dart';
// import 'package:bus_eka/screens/home/home.dart';
import 'package:bus_eka/screens/register_screen.dart';
import 'package:bus_eka/screens/passenger/passenger_options.dart';
// import 'package:bus_eka/screens/track_anonymous/map.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/util_functions.dart';
// import 'package:bus_eka/widgets/yellowbutton.dart';
import 'package:bus_eka/widgets/text_feild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoaging = false;

  @override
  void dispose() {
    super.dispose();
    //dispose the controllers
    _emailController.dispose();
    _passwordController.dispose();
  }

  //auth logic instance
  final AuthMethodes _authMethodes = AuthMethodes();

  void loginUser() async {
    if (mounted) {
      setState(() {
        isLoaging = true;
      });
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    String result = await _authMethodes.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (mounted) {
      setState(() {
        isLoaging = false;
      });
    }

    if (result != 'success') {
      showSnackBar(context, result);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PassengerOption(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //for the top space
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                //image for logo
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/buseka.png',
                    height: 100,
                  ),
                ),
                const SizedBox(
                  height: 34,
                ),

                //text feild for email
                TextFeildInput(
                  hintText: 'Enter Email',
                  controller: _emailController,
                  isPassword: false,
                  inputkeyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 30,
                ),
                //text feild for password
                TextFeildInput(
                  hintText: 'Enter Password',
                  controller: _passwordController,
                  isPassword: true,
                  inputkeyboardType: TextInputType.visiblePassword,
                ),
                //button for login

                const SizedBox(
                  height: 50,
                ),

                // YellowButton(
                //   text: 'Log in',
                //   onPressed: loginUser,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainYellowColor,
                    fixedSize: const Size(300, 50), // Set the width and height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Set the border radius
                    ),
                  ),
                  onPressed: loginUser,
                  child: const Text(
                    'Log in',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),

                SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
}
