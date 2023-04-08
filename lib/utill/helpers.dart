import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/repositories/rest/medical_repository.dart';

var medicalRepository = MedicalRestRepository();

Doctor? findDoctorById(List<Doctor> doctors, String doctorId) {
  for (var doctor in doctors) {
    if (doctor.id == doctorId) {
      return doctor;
    }
  }
  return null;
}

UserClass? findUserById(String patientId) {
  List<UserClass> users = getIt<MedicalBloc>().state.users;
  for (var patient in users) {
    if (patient.id == patientId) {
      return patient;
    }
  }
  return null;
}

List<Review> findReviewsByDoctorId(List<Review> allReviews, String doctorId) {
  List<Review> doctorReviews = [];
  doctorReviews =
      allReviews.where((review) => review.doctorId == doctorId).toList();

  return doctorReviews;
}

bool hasAppointmentConfirmedBefore(
    List<Appointment> allAppointments, String doctorId) {
  for (var app in allAppointments) {
    if (app.doctorId == doctorId &&
        app.dateAndTime.isBefore(DateTime.now()) &&
        app.confirmed == true) {
      return true;
    }
  }
  return false;
}

void addReview(int stars, String comment, String doctorId, String userId) {
  medicalRepository.addReview(comment, stars, doctorId, userId);
}
