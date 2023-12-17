import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/admin_login.dart';
import 'package:bus_eka/utils/colors.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onSignOut;
  final String? userName; // Pass the current user's name as a parameter

  const AppDrawer({
    Key? key,
    required this.onSignOut,
    this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: mainBlueColor,
            ),
            child: Text(
              'BusEka',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Nothing Do'),
            onTap: () {
              // Close the drawer
            },
          ),
          ListTile(
            title: Text('Nothing Do'),
            onTap: () {
              // Close the drawer
            },
          ),
          ListTile(
            title: Text('Nothing Do'),
            onTap: () {
              // Close the drawer
            },
          ),
          ListTile(
            title: Text('Admin'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (context) => AdminOption(),
                  builder: (context) => AdminLoginPage(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              onSignOut(); // Call the provided sign-out callback
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
