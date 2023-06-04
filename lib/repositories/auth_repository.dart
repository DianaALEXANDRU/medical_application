import 'dart:async';

import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';

abstract class AuthRepository {
  Future<void> register({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String email,
    required String password,
  });

  Future<void> logIn({
    required String email,
    required String password,
  });

  Future<void> passwordReset({
    required String email,
  });

  Future<void> logOut();

  Future<UserClass?> fetchUser();

  Future<Doctor> fetchDoctor();
}
