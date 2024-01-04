// ignore_for_file: dead_code

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user.dart' as user_model;

class AuthMethodes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Update loyaltycount for the user
  Future<void> updateLoyaltyCount(String uid, int newLoyaltyCount) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'loyaltycount': newLoyaltyCount,
      });
    } catch (e) {
      print('Error updating loyaltycount: $e');
      throw e; // You may want to handle this error in the calling code
    }
  }

  // //get the current user details
  Future<user_model.User?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();

        return user_model.User.fromJSON(
            snapshot.data() as Map<String, dynamic>);
      } else {
        // Return null if no user is signed in
        return null;
      }
    } catch (e) {
      print("Error getting current user: $e");
      return null;
    }
  }

  //register new user
  Future<String> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String userName,
    required String phoneno,
    String? usercredential,
  }) async {
    String res = "Enter Data to Field";

    try {
      //if the inputs are not empty
      if (userName.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          phoneno.isNotEmpty) {
        //create a new user with email and password
        final UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);

        //user model
        user_model.User user = user_model.User(
          uid: userCredential.user!.uid,
          email: email,
          userName: userName,
          phoneno: phoneno,
          loyaltycount: 0,
          usercredential: "passenger",
        );

        //if the user is created store the user data in the firestore
        if (userCredential.user != null) {
          //store the user data in the firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(
                user.toJSON(),
              );

          res = "success";
        }
      }
    }

    //catch the errors extra error handling
    on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "weak-password") {
        res = "Weak password";
      } else if (error.code == "email-already-in-use") {
        res = "Email already in use";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //login user
  Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    String res = "An error occured";

    try {
      //if the inputs are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        //login the user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "success";
      } else {
        res = "Please enter email and password";
      }
    }

    //catch the errors extra error handling
    on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "weak-password") {
        res = "Weak password";
      } else if (error.code == "email-already-in-use") {
        res = "Email already in use";
      }
    } catch (error) {
      res = error.toString();
    }

    return res;
  }

  //sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (err) {
      print(err.toString());
      // Handle the sign-out error if needed
    }
  }
}
