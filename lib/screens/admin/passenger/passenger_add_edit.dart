import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/passenger/passenger_firebase_service.dart';
import 'package:bus_eka/screens/admin/passenger/passenger_model.dart';
import 'package:uuid/uuid.dart';

class AddEditPassengerPage extends StatefulWidget {
  final User? user;

  AddEditPassengerPage({Key? key, this.user}) : super(key: key);

  @override
  _AddEditPassengerPageState createState() => _AddEditPassengerPageState();
}

class _AddEditPassengerPageState extends State<AddEditPassengerPage> {
  final PassengerFirebaseService _firebaseService = PassengerFirebaseService();
  final GlobalKey<FormState> _passengerformKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userLoyaltyController = TextEditingController();
  final TextEditingController _userPhoneNoController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _usercredentialController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _userEmailController.text = widget.user!.email;
      _userLoyaltyController.text = widget.user!.loyaltycount.toString();
      _userPhoneNoController.text = widget.user!.phoneno;
      _userNameController.text = widget.user!.userName;
      _usercredentialController.text = widget.user!.usercredential;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _passengerformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _userEmailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _userLoyaltyController,
                  decoration: InputDecoration(labelText: 'Loyalty Count'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter loyalty count';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.0),
                TextFormField(
                  controller: _userPhoneNoController,
                  decoration: InputDecoration(labelText: 'Phone No'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(labelText: 'User Name'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _usercredentialController,
                  decoration: InputDecoration(labelText: 'Credential'),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user credential';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_passengerformKey.currentState?.validate() ?? false) {
                      _saveBus();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.user == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveBus() {
    final String uid = widget.user?.uid ?? Uuid().v4();
    final String email = _userEmailController.text;
    final int loyaltycount = int.parse(_userLoyaltyController.text);
    final String phoneno = _userPhoneNoController.text;
    final String userName = _userNameController.text;
    final String usercredential = _usercredentialController.text;

    User user = User(
      uid: uid,
      email: email,
      loyaltycount: loyaltycount,
      phoneno: phoneno,
      userName: userName,
      usercredential: usercredential,
    );

    if (widget.user == null) {
      _firebaseService.addUser(user);
    } else {
      _firebaseService.updateUser(user);
    }
  }
}
