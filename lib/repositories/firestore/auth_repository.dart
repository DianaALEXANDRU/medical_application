import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/entities/user_entity.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
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
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
  Future<UserClass> fetchUser() async {
    final id = FirebaseAuth.instance.currentUser?.uid;

    // Get the document reference from Firestore
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('users').doc(id);

    // Get the document snapshot from Firestore
    DocumentSnapshot documentSnapshot = await documentReference.get();
    print(
        '#######################################Docrument refarances: $documentReference');
    print(
        '#######################################Docrument snapshot: $documentSnapshot');
    // Convert the document data to a JSON string
    Map<String, dynamic> jsonData =
        documentSnapshot.data() as Map<String, dynamic>;

    jsonData['id'] = id; // Add the extra field with the uid

    String jsonString = jsonEncode(jsonData);

    UserEntity currentUser = UserEntity.fromJson(jsonData);

    return UserClass.fromEntity(currentUser);
  }
}
