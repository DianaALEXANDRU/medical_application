import 'dart:async';

import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/models/user.dart';

abstract class MedicalRepository {
  Future<List<Doctor>> fetchDoctors();

  Future<List<UserClass>> fetchUsers();

  Future<List<Category>> fetchCategories();

  Future<List<Appointment>> fetchAppointmentsForUser(String userId);

  Future<List<Appointment>> fetchAppointmentsForDoctor(String doctorId);

  Future<UserClass> fetchUser();

  Future<UserClass> fetchUserById(String id);

  Future<void> deleteAppointment(String appointmentId);

  Future<void> confirmeAppointment(String appointmentId);

  Future<void> addReview(
      String comment, int stars, String doctorId, String userId);

  Future<List<Review>> fetchReviewByDoctorId(String doctorId);

  Future<List<Review>> fetchReviews();
}
