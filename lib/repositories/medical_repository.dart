import 'dart:async';

import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';

abstract class MedicalRepository {
  Future<List<Doctor>> fetchDoctors();

  Future<List<Category>> fetchCategories();

  Future<List<Appointment>> fetchAppointments(int userId);

  Future<UserClass> fetchUser();
}
