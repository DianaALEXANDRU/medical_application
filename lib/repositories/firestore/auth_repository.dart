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
    try {
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Future<void> passwordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // showDialog(context: context, builder: (context){
      //   return const AlertDialog(
      //     content: Text('Password  reset link sent!'),
      //   );
      // }); //TODO afisez mesaj in pagina

    } on FirebaseAuthException catch (e) {
      print(e);
      // showDialog(context: context, builder: (context){
      //   return AlertDialog(
      //     content: Text(e.message.toString()),
      //   );
      // });  //TODO afisez mesaj in pagina
    }
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
    };

    DoctorEntity doctor = DoctorEntity.fromJson(combinedMap);

    return Doctor.fromEntity(doctor);
  }
}
