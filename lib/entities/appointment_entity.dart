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
  static const String fieldConfirmed = 'confirmed';

  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateAndTime;
  final bool confirmed;

  const AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateAndTime,
    required this.confirmed,
  });

  static AppointmentEntity fromJson(Map<String, dynamic> json) =>
      AppointmentEntity(
        id: json[fieldId],
        patientId: json[fieldPatientId],
        doctorId: json[fieldDoctorId],
        dateAndTime:
            Utility.combineDateAndTime(json[fieldDate], json[fieldTime]),
        confirmed: json[fieldConfirmed],
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldPatientId: patientId,
        fieldDoctorId: doctorId,
        fieldDate: dateAndTime,
        fieldTime: '', //TODO fa split la date and time si aici si la fieldDate,
        fieldConfirmed: confirmed,
      };

  @override
  List<Object> get props => [id, patientId, doctorId, dateAndTime, confirmed];
}
