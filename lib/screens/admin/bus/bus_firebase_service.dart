import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka/screens/admin/bus/bus_model.dart';
// import 'package:flutter_firebase_crud/models/Bus_model.dart';

class BusFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBus(Bus bus) async {
    await _firestore
        .collection('buscolection')
        .doc(bus.busid)
        .set(bus.toJson());
  }

  Stream<List<Bus>> getBuss() {
    return _firestore.collection('buscolection').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Bus.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateBus(Bus bus) async {
    await _firestore
        .collection('buscolection')
        .doc(bus.busid)
        .update(bus.toJson());
  }

  Future<void> deleteBus(String busId) async {
    await _firestore.collection('buscolection').doc(busId).delete();
  }
}
