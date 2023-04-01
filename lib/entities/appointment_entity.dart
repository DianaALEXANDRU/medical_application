import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/utill/utillity.dart';
import 'package:meta/meta.dart';

@immutable
class AppointmentEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldPatientId = 'patient_id';
  static const String fieldDoctorId = 'doctor_id';
  static const String fieldDate = 'date';
  static const String fieldTime = 'time';

  final String id;
  final String patientId;
  final String doctorId; // Doctor entity
  final DateTime date;
  final TimeOfDay time;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
  });

  static AppointmentEntity fromJson(Map<String, dynamic> json) =>
      AppointmentEntity(
        id: json[fieldId],
        patientId: json[fieldPatientId],
        doctorId: json[fieldDoctorId],
        date: Utility.stringToDateTime(json[fieldDate]),
        time: Utility.stringToTimeOfDay(json[fieldTime]),
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldPatientId: patientId,
        fieldDoctorId: doctorId,
        fieldDate: date,
        fieldTime: time,
      };

  @override
  List<Object> get props => [
        id,
        patientId,
        doctorId,
        date,
        time,
      ];
}
