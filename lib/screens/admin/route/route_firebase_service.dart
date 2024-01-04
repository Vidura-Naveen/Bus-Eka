import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka_test/screens/admin/route/route_model.dart';

class RouteFirebaseService {
  final FirebaseFirestore _rfirestore = FirebaseFirestore.instance;

  Future<void> addRoute(Routez route) async {
    await _rfirestore
        .collection('routcolection')
        .doc(route.routeid)
        .set(route.toJson());
  }

  Stream<List<Routez>> getRoutes() {
    return _rfirestore.collection('routcolection').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Routez.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateRoute(Routez route) async {
    await _rfirestore
        .collection('routcolection')
        .doc(route.routeid)
        .update(route.toJson());
  }

  Future<void> deleteRoute(String routeId) async {
    await _rfirestore.collection('routcolection').doc(routeId).delete();
  }
}
