part of 'medical_bloc.dart';

abstract class MedicalEvent extends Equatable {
  const MedicalEvent();
}

class FetchDoctors extends MedicalEvent {
  const FetchDoctors();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchUsers extends MedicalEvent {
  const FetchUsers();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchCategories extends MedicalEvent {
  const FetchCategories();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchAppointmentsForUser extends MedicalEvent {
  final String userId;

  const FetchAppointmentsForUser({required this.userId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userId];
}

class FetchAppointmentsForDoctor extends MedicalEvent {
  final String userId;

  const FetchAppointmentsForDoctor({required this.userId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userId];
}

class FetchReviews extends MedicalEvent {
  const FetchReviews();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchReviewsByDoctorId extends MedicalEvent {
  final String doctorId;

  const FetchReviewsByDoctorId({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class FetchFreeHours extends MedicalEvent {
  final String doctorId;
  final DateTime date;

  const FetchFreeHours({required this.doctorId, required this.date});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId, date];
}

class FetchProgramDays extends MedicalEvent {
  final String doctorId;

  const FetchProgramDays({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class FetchProgram extends MedicalEvent {
  final String doctorId;

  const FetchProgram({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class ConfirmeAppointment extends MedicalEvent {
  final String appointmentId;

  const ConfirmeAppointment({required this.appointmentId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [appointmentId];
}

class DeleteAppointment extends MedicalEvent {
  final String appointmentId;

  const DeleteAppointment({required this.appointmentId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [appointmentId];
}

class AddAppointment extends MedicalEvent {
  final String patientId;
  final String doctorId;
  final String hour;
  final DateTime date;

  const AddAppointment({
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.hour,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        patientId,
        doctorId,
        date,
        hour,
      ];
}

class EditUserDetails extends MedicalEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNo;

  const EditUserDetails({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        phoneNo,
      ];
}
