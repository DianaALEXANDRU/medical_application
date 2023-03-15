import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:meta/meta.dart';

@immutable
class AppointmentEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldPatient = 'patient';
  static const String fieldDoctor = 'doctor';
  static const String fieldDate = 'date';
  static const String fieldTime = 'time';

  final int id;
  final String patient;
  final DoctorEntity doctor; // Doctor entity
  final String date;
  final String time;

  const AppointmentEntity({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.date,
    required this.time,
  });

  static AppointmentEntity fromJson(Map<String, dynamic> json) =>
      AppointmentEntity(
        id: json[fieldId],
        patient: json[fieldPatient],
        doctor: DoctorEntity.fromJson(json[fieldDoctor]),
        date: json[fieldDate] ?? '',
        time: json[fieldTime] ?? '',
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldPatient: patient,
        fieldDoctor: doctor,
        fieldDate: date,
        fieldTime: time,
      };

  @override
  List<Object> get props => [
        id,
        patient,
        doctor,
        date,
        time,
      ];
}
