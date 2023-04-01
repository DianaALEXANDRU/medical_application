import 'dart:async';

import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';

abstract class MedicalRepository {
  Future<List<Doctor>> fetchDoctors();

  Future<List<Category>> fetchCategories();

  Future<List<Appointment>> fetchAppointmentsForUser(String userId);

  Future<List<Appointment>> fetchAppointmentsForDoctor(String doctorId);

  Future<UserClass> fetchUser();

  Future<void> deleteAppointment(String appointmentId);
}
