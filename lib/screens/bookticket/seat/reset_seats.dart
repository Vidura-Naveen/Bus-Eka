import 'package:cloud_firestore/cloud_firestore.dart';

class SeatResetService {
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _seatCollection =
      FirebaseFirestore.instance.collection('seatCollection');

  Future<void> resetAllSeats(String busId, String routeId, int seatCount,
      DateTime selectedDate) async {
    await _seatCollection.doc('${selectedDate}${busId}${routeId}').update({
      'seatStatus': List.generate(seatCount, (index) => false),
    });
  }
}
