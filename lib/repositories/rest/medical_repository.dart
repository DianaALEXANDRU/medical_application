import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/entities/appointment_entity.dart';
import 'package:medical_application/entities/category_entity.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:medical_application/entities/review_entity.dart';
import 'package:medical_application/entities/user_entity.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/models/user.dart' as my_user;
import 'package:medical_application/models/user.dart';
import 'package:medical_application/repositories/medical_repository.dart';
import 'package:medical_application/utill/utillity.dart';

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
  Future<List<UserClass>> fetchUsers() async {
    List<UserClass> list = [];

    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "user")
        .get();

    for (DocumentSnapshot app in userSnapshot.docs) {
      String uid = app.id;

      Map<String, dynamic> userMap = {
        'id': uid,
        'first_name': app.get('first_name'),
        'last_name': app.get('last_name'),
        'phone_no': app.get('phone_no'),
        'role': app.get('role'),
      };

      UserEntity user = UserEntity.fromJson(userMap);

      list.add(UserClass.fromEntity(user));
    }

    return list;
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
  Future<my_user.UserClass> fetchUserById(String id) async {
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
  Future<List<Appointment>> fetchAppointmentsForDoctor(String doctorId) async {
    List<Appointment> appointmentsList = [];

    QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('doctor_id', isEqualTo: doctorId)
        .get();

    for (DocumentSnapshot app in appointmentsSnapshot.docs) {
      String uid = app.id;

      Map<String, dynamic> appointmentMap = {
        'id': uid,
        'patient_id': app.get('patient_id'),
        'doctor_id': app.get('doctor_id'),
        'date': app.get('date'),
        'time': app.get('time'),
        'confirmed': app.get('confirmed')
      };

      AppointmentEntity appointment =
          AppointmentEntity.fromJson(appointmentMap);

      appointmentsList.add(Appointment.fromEntity(appointment));
    }
    Utility.sortListByDateTime(appointmentsList);
    return appointmentsList;
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
        'confirmed': app.get('confirmed'),
      };

      AppointmentEntity appointment =
          AppointmentEntity.fromJson(appointmentMap);

      appointmentsList.add(Appointment.fromEntity(appointment));
    }

    Utility.sortListByDateTime(appointmentsList);

    return appointmentsList;
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .delete();
  }

  @override
  Future<void> addReview(
      String comment, int stars, String doctorId, String userId) async {
    final Map<String, dynamic> review = {
      "doctor_id": doctorId,
      "patient_id": userId,
      "date_and_time": DateTime.now().toString(),
      "comment": comment,
      "stars": stars,
    };

    await FirebaseFirestore.instance.collection("reviews").add(review);
  }

  @override
  Future<List<Review>> fetchReviewByDoctorId(String doctorId) async {
    List<Review> reviewsList = [];

    QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('doctor_id', isEqualTo: doctorId)
        .get();

    for (DocumentSnapshot review in reviewSnapshot.docs) {
      String uid = review.id;

      Map<String, dynamic> reviewMap = {
        'id': uid,
        'patient_id': review.get('patient_id'),
        'doctor_id': review.get('doctor_id'),
        'date_and_time': review.get('date_and_time'),
        'comment': review.get('comment'),
        'stars': review.get('stars'),
      };

      ReviewEntity reviewEntity = ReviewEntity.fromJson(reviewMap);

      reviewsList.add(Review.fromEntity(reviewEntity));
    }

    return reviewsList;
  }

  @override
  Future<List<Review>> fetchReviews() async {
    List<Review> reviewsList = [];

    QuerySnapshot reviewSnapshot =
        await FirebaseFirestore.instance.collection('reviews').get();

    for (DocumentSnapshot review in reviewSnapshot.docs) {
      String uid = review.id;

      Map<String, dynamic> reviewMap = {
        'id': uid,
        'patient_id': review.get('patient_id'),
        'doctor_id': review.get('doctor_id'),
        'date_and_time': review.get('date_and_time'),
        'comment': review.get('comment'),
        'stars': review.get('stars'),
      };

      ReviewEntity reviewEntity = ReviewEntity.fromJson(reviewMap);

      reviewsList.add(Review.fromEntity(reviewEntity));
    }

    return reviewsList;
  }

  @override
  Future<void> confirmeAppointment(String appointmentId) async {
    final data = {"confirmed": true};
    await FirebaseFirestore.instance
        .collection("appointments")
        .doc(appointmentId)
        .set(data, SetOptions(merge: true));
  }

  @override
  Future<void> editUserDetails(
      String userId, String firstName, String lastName, String phoneNo) async {
    Map<String, String> data = {};
    if (firstName != '') {
      data['first_name'] = firstName;
    }
    if (lastName != '') {
      data['last_name'] = lastName;
    }
    if (phoneNo != '') {
      data['phone_no'] = phoneNo;
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .set(data, SetOptions(merge: true));
  }

  @override
  Future<Map<int, List<AppointmentHours>>> fetchProgram(String doctorId) async {
    final program = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(doctorId)
        .collection('program')
        .get();

    Map<int, List<AppointmentHours>> mapProgram = {};

    if (program.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in program.docs) {
        Map<String, dynamic> p = documentSnapshot.data();
        if (p['start_hour'] == null) {
          return {};
        }
        AppointmentHours makeHours = AppointmentHours(
            id: documentSnapshot.id,
            startHour: p['start_hour'],
            endHour: p['end_hour']);
        if (mapProgram.containsKey(p['day_of_week'])) {
          mapProgram[p['day_of_week']]?.addAll([makeHours]);
        } else {
          mapProgram[p['day_of_week']] = [makeHours];
        }
      }
    }

    return mapProgram;
  }

  @override
  Future<void> makeAppointment(
      String patientId, String doctorId, DateTime date, String hour) async {
    final Map<String, dynamic> app = {
      "doctor_id": doctorId,
      "patient_id": patientId,
      "date": DateFormat("dd/MM/yyyy").format(date),
      "time": hour,
      "confirmed": false,
    };

    await FirebaseFirestore.instance.collection("appointments").add(app);
  }

  @override
  Future<List<int>> fetchProgramDays(String doctorId) async {
    final program = await FirebaseFirestore.instance
        .collection('doctor')
        .doc(doctorId)
        .collection('program')
        .get();

    Set<int> setProgram = {};

    if (program.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in program.docs) {
        Map<String, dynamic> p = documentSnapshot.data();
        setProgram.add(p['day_of_week']);
      }
    }

    List<int> listProgram = [];
    for (var element in setProgram) {
      listProgram.add(element);
    }

    return listProgram;
  }
}
