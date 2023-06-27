import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:medical_application/entities/user_entity.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/repositories/auth_repository.dart';

class AuthRepositoryFirestore extends AuthRepository {
  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String email,
    required String password,
  }) async {

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(value.user?.uid)
              .set(
            {
              "first_name": firstName,
              "last_name": lastName,
              "phone_no": phoneNo,
              "role": 'user',
              "email": email,
            },
          );
        },
      );

  }

  @override
  Future<void> logIn({
    required String email,
    required String password,
  }) async {


      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  }

  @override
  Future<void> passwordReset({required String email}) async {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);


  }

  @override
  Future<void> logOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserClass?> fetchUser() async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(id);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.data() == null) {
      return null;
    }
    Map<String, dynamic> jsonData =
        documentSnapshot.data() as Map<String, dynamic>;

    jsonData['id'] = id;

    UserEntity currentUser = UserEntity.fromJson(jsonData);

    return UserClass.fromEntity(currentUser);
  }

  @override
  Future<Doctor> fetchDoctor() async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    DocumentSnapshot userDetails =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    DocumentSnapshot doctorDetails =
        await FirebaseFirestore.instance.collection('doctor').doc(id).get();

    Map<String, dynamic> combinedMap = {
      'id': id,
      'first_name': userDetails.get('first_name'),
      'last_name': userDetails.get('last_name'),
      'phone_no': userDetails.get('phone_no'),
      'role': userDetails.get('role'),
      'email': userDetails.get('email'),
      'description': doctorDetails.get('description'),
      'experience': doctorDetails.get('experience'),
      'image_url': doctorDetails.get('image_url'),
      'category': doctorDetails.get('category'),
      'available': doctorDetails.get('available'),
    };

    DoctorEntity doctor = DoctorEntity.fromJson(combinedMap);

    return Doctor.fromEntity(doctor);
  }
}
