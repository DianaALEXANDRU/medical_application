import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DBHelper {
  static Future deleteAppointment(String appointmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    } catch (e) {
      return false;
    }
  }
}
