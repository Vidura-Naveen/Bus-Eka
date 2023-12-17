import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/admin_option.dart';
import 'package:bus_eka/screens/home.dart';
import 'package:bus_eka/utils/colors.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showBanner = false;

  void _login() {
    // List of hardcoded email and password pairs
    List<Map<String, String>> credentials = [
      {"email": "vidura@gmail.com", "password": "admin"},
      {"email": "ishara@gmail.com", "password": "admin1"},
      {"email": "harsha@gmail.com", "password": "admin2"},
    ];

    // Check if the entered email and password match any of the pairs
    for (var credential in credentials) {
      if (emailController.text == credential['email'] &&
          passwordController.text == credential['password']) {
        // Navigate to the success page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminOption(),
          ),
        );
        return;
      }
    }

    // If no match is found, show error banner
    setState(() {
      showBanner = true;
    });
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
                    height: 80,
                  ),
                ),
                const SizedBox(
                  height: 44,
                ),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlueColor,
                    elevation: 4, // background color
                  ),
                ),

                SizedBox(height: 16.0),
                if (showBanner)
                  Text(
                    'Enter valid email and password',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}















//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login Panel'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//             SizedBox(height: 16.0),
//             if (showBanner)
//               Text(
//                 'Enter valid email and password',
//                 style: TextStyle(color: Colors.red),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SuccessPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Success Page'),
//       ),
//       body: Center(
//         child: Text('Login Successful!'),
//       ),
//     );
//   }
// }
