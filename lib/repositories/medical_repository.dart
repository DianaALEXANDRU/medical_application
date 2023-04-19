import 'dart:async';

import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
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

  Future<void> editUserDetails(
      String userId, String firstName, String lastName, String phoneNo);

  Future<Map<int, List<AppointmentHours>>> fetchProgram(String doctorId);

  Future<List<int>> fetchProgramDays(String doctorId);

  Future<void> makeAppointment(
      String patientId, String doctorId, DateTime date, String hour);
}
