import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';

abstract class Helpers {
  static Doctor? findDoctorById(List<Doctor> doctors, String doctorId) {
    for (var doctor in doctors) {
      if (doctor.id == doctorId) {
        return doctor;
      }
    }
    return null;
  }

  static UserClass? findUserById(List<UserClass> users, String patientId) {
    for (var patient in users) {
      if (patient.id == patientId) {
        return patient;
      }
    }
    return null;
  }
}
