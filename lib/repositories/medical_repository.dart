import 'dart:async';
import 'dart:typed_data';

import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/programDto.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/models/user.dart';

abstract class MedicalRepository {
  Future<List<Doctor>> fetchDoctors();

  Future<List<UserClass>> fetchUsers();

  Future<List<Category>> fetchCategories();

  Future<List<Appointment>> fetchAllAppointments();

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

  ///add doctor
  Future<void> updateRole(String userId);

  Future<void> addDoctor(
      String category, String experience, String description);

  Future<void> addProgram(List<Program> program, String doctorId);

  Future<void> makeDoctor(
    String userId,
    String category,
    String experience,
    String description,
    List<Program> program,
    String selctFile,
    Uint8List? selectedImageInBytes,
  );

  /// add category
  Future<void> addCategory(
    String name,
    String selctFile,
    Uint8List? selectedImageInBytes,
  );

  Future<void> editCategory(
    String name,
    String selctFile,
    Uint8List? selectedImageInBytes,
    Category category,
  );

  Future<void> editProfilePicture(
      String doctorId,
      String selctFile,
      Uint8List? selectedImageInBytes,

      );

  Future<void> deleteCategory(Category category);

  Future<void> editDoctorDetails(Doctor doctor, String category, String experience, String description);
}
