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
  Future<List<Doctor>> fetchDoctors() async {
    List<dynamic> doctorsJson = await Future.delayed(
      const Duration(seconds: 1),
      () => [
        {
          'id': 12,
          'name': 'Muntean Costel',
          'image_url':
              'https://img.freepik.com/free-photo/portrait-young-male-doctor-with-stethoscope_171337-5084.jpg?w=1380&t=st=1675766319~exp=1675766919~hmac=640e42204a92bf6354a9c42e079866552653d18b0c357a51c98dc783611f153d',
          'description':
              '3 Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          'category': 'Ortopedy',
          'rating': '4.9'
        },
        {
          'id': 1,
          'name': 'John Doe',
          'image_url':
              'https://img.freepik.com/free-photo/smiling-doctor-with-strethoscope-isolated-grey_651396-974.jpg?w=1380&t=st=1675766256~exp=1675766856~hmac=48b331ca7030463b3fb023efd7d9b62fe593d41331bdbdf56ba00aec37a4f378',
          'description':
              '1 Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          'category': 'Cardiology',
          'rating': '3.0',
        },
        {
          'id': 2,
          'name': 'Jane Doe',
          'image_url':
              'https://img.freepik.com/free-photo/portrait-disappointed-doctor-woman-medical-worker-pointing-fingers-right-looking-sad-regret-g_1258-86069.jpg?w=1380&t=st=1675766288~exp=1675766888~hmac=56d510a843bbda5123f82acc8069425a60d8b42283b78755150d0fae4cb0ba11',
          'description':
              'A doctor is responsible for all sides of care of a patient. They diagnose, educate, and treat patients to ensure that they have the best possible care. A few of the main duties of a doctor are performing diagnostic tests, recommending specialists ',
          'category': 'Cardiology',
          'rating': '5.0'
        },
        {
          'id': 3,
          'name': 'John Smith',
          'image_url':
              'https://img.freepik.com/free-photo/portrait-young-male-doctor-with-stethoscope_171337-5084.jpg?w=1380&t=st=1675766319~exp=1675766919~hmac=640e42204a92bf6354a9c42e079866552653d18b0c357a51c98dc783611f153d',
          'description':
              '3 Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          'category': 'Ortopedy',
          'rating': '4.9'
        },
        {
          'id': 4,
          'name': 'Jane Smith',
          'image_url':
              'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-closed-posture_409827-254.jpg?w=1380&t=st=1675766300~exp=1675766900~hmac=adfe7bbaacbd5d518f90f5443a23e2126c310544a7d2c9e8b40c718874e18206',
          'description':
              '4 Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          'category': 'Ortopedy',
          'rating': '5.0'
        },
      ],
    );

    return doctorsJson
        .map(
          (element) => Doctor.fromEntity(
            DoctorEntity.fromJson(element as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  Future<List<Category>> fetchCategories() async {
    var db = FirebaseFirestore.instance;

    // Get Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Get collection reference
    CollectionReference collectionRef = firestore.collection('category');

    // Get collection documents
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Convert documents to Map
    List<Object?> documents =
        querySnapshot.docs.map((doc) => doc.data()).toList();

    // Convert Map to JSON
    String jsonString = jsonEncode(documents);

    // Return JSON object
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
  Future<List<Appointment>> fetchAppointments(int userId) async {
    List<dynamic> appointmentsJson = await Future.delayed(
      const Duration(seconds: 1),
      () => [
        {
          'id': 1,
          'patient': 'Popescu Ion',
          'doctor': {
            'id': 12,
            'name': 'Muntean Costel',
            'image_url':
                'https://img.freepik.com/free-photo/portrait-young-male-doctor-with-stethoscope_171337-5084.jpg?w=1380&t=st=1675766319~exp=1675766919~hmac=640e42204a92bf6354a9c42e079866552653d18b0c357a51c98dc783611f153d',
            'description':
                '3 Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            'category': 'Ortopedy',
            'rating': '4.9'
          },
          'date': '2023-03-21',
          'time': '12:50:00',
        },
      ],
    );

    return appointmentsJson
        .map(
          (element) => Appointment.fromEntity(
            AppointmentEntity.fromJson(element as Map<String, dynamic>),
          ),
        )
        .toList();
  }

  @override
  Future<my_user.UserClass> fetchUser() async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    // Get the document reference from Firestore
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(id);

    // Get the document snapshot from Firestore
    DocumentSnapshot documentSnapshot = await documentReference.get();

    // Convert the document data to a JSON string
    Map<String, dynamic> jsonData =
        documentSnapshot.data() as Map<String, dynamic>;

    jsonData['id'] = id; // Add the extra field with the uid

    String jsonString = jsonEncode(jsonData);

    UserEntity currentUser = UserEntity.fromJson(jsonData);

    return UserClass.fromEntity(currentUser);
  }
}
