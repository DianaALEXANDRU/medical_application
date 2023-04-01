import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_application/entities/appointment_entity.dart';
import 'package:medical_application/entities/category_entity.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:medical_application/entities/user_entity.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart' as my_user;
import 'package:medical_application/models/user.dart';
import 'package:medical_application/repositories/medical_repository.dart';

class MedicalRestRepository extends MedicalRepository {
  MedicalRestRepository();

  @override
  Future<List<Category>> fetchCategories() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionRef = firestore.collection('category');
    QuerySnapshot querySnapshot = await collectionRef.get();

    List<Object?> documents =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    String jsonString = jsonEncode(documents);

    List<dynamic> categoriesJson = jsonDecode(jsonString);
    return categoriesJson
        .map(
          (element) => Category.fromEntity(
            CategoryEntity.fromJson(element as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  Future<my_user.UserClass> fetchUser() async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(id);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    Map<String, dynamic> jsonData =
        documentSnapshot.data() as Map<String, dynamic>;

    jsonData['id'] = id;

    UserEntity currentUser = UserEntity.fromJson(jsonData);

    return UserClass.fromEntity(currentUser);
  }

  @override
  Future<List<Doctor>> fetchDoctors() async {
    List<Doctor> combinedList = [];

    QuerySnapshot collection1Snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "doctor")
        .get();

    QuerySnapshot collection2Snapshot =
        await FirebaseFirestore.instance.collection('doctor').get();

    for (DocumentSnapshot collection1Doc in collection1Snapshot.docs) {
      String uid = collection1Doc.id;

      try {
        DocumentSnapshot collection2Doc =
            collection2Snapshot.docs.firstWhere((doc) => doc.id == uid);

        Map<String, dynamic> combinedMap = {
          'id': uid,
          'first_name': collection1Doc.get('first_name'),
          'last_name': collection1Doc.get('last_name'),
          'phone_no': collection1Doc.get('phone_no'),
          'role': collection1Doc.get('role'),
          'description': collection2Doc.get('description'),
          'experience': collection2Doc.get('experience'),
          'image_url': collection2Doc.get('image_url'),
          'category': collection2Doc.get('category')
        };

        DoctorEntity currentDoctor = DoctorEntity.fromJson(combinedMap);

        combinedList.add(Doctor.fromEntity(currentDoctor));
      } catch (e) {
        print('No document found for id: ${e.toString()}');
      }
    }

    return combinedList;
  }

  @override
  Future<List<Appointment>> fetchAppointmentsForDoctor(String doctorId) {
    // TODO: implement fetchAppointmentsForDoctor
    throw UnimplementedError();
  }

  @override
  Future<List<Appointment>> fetchAppointmentsForUser(String userId) async {
    List<Appointment> appointmentsList = [];

    QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('patient_id', isEqualTo: userId)
        .get();

    for (DocumentSnapshot app in appointmentsSnapshot.docs) {
      String uid = app.id;

      Map<String, dynamic> appointmentMap = {
        'id': uid,
        'patient_id': app.get('patient_id'),
        'doctor_id': app.get('doctor_id'),
        'date': app.get('date'),
        'time': app.get('time'),
      };

      AppointmentEntity appointment =
          AppointmentEntity.fromJson(appointmentMap);

      appointmentsList.add(Appointment.fromEntity(appointment));
    }
    return appointmentsList;
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await FirebaseFirestore.instance
        .collection("appointments")
        .doc("appointmentIs")
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }
}
