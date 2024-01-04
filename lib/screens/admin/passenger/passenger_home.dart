import 'package:flutter/material.dart';
import 'package:bus_eka_test/screens/admin/passenger/passenger_add_edit.dart';
import 'package:bus_eka_test/screens/admin/passenger/passenger_firebase_service.dart';
import 'package:bus_eka_test/screens/admin/passenger/passenger_model.dart';

class PassengerCrud extends StatefulWidget {
  @override
  _PassengerCrudState createState() => _PassengerCrudState();
}

class _PassengerCrudState extends State<PassengerCrud> {
  final PassengerFirebaseService _firebaseService = PassengerFirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger List'),
      ),
      body: StreamBuilder<List<User>>(
        stream: _firebaseService.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<User> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              User user = users[index];
              return ListTile(
                title: Text(user.userName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${user.email}'),
                    Text('Phone Number: ${user.phoneno}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditUser(context, user);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _firebaseService.deleteUser(user.uid);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _navigateToAddUser(context);
      //   },
      //   tooltip: 'Add User',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  void _navigateToAddUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditPassengerPage()),
    );
  }

  void _navigateToEditUser(BuildContext context, User user) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditPassengerPage(user: user)),
    );
  }
}
