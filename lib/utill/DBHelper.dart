import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DBHelper {
  //TODO muta in repo
  static Future<List<Map<String, dynamic>>> fetchProgram(
      String doctorId) async {
    final program = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .collection('program')
        .get();

    if (program.docs.isEmpty) {
      return [];
    }

    final programList = program.docs.map((p) {
      return {
        'id': p.id,
        'day_of_week': p['day_of_week'],
        'start_time': p['start_time'],
        'end_time': p['end_time']
      };
    }).toList();

    return programList;
  }

  static Future deleteAppointment(String appointmentId) async {
    print("######################## A Ajund in BDHelper DeleteAppointment");
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete()
          .then(
            (doc) => print("Document deleted"),
            onError: (e) => print("Error updating document $e"),
          );
    } catch (e) {
      print("##################### Delete error ${e.toString()}");

      return false;
    }
  }
}
