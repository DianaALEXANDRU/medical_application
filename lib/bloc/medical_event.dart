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
