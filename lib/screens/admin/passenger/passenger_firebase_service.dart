// import 'package:admin_auth/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka_test/screens/admin/passenger/passenger_model.dart';
// import 'package:flutter_firebase_crud/models/user_model.dart';

class PassengerFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(User user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Stream<List<User>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateUser(User user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }
}
