import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/entities/appointment_entity.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:meta/meta.dart';

@immutable
class Appointment extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime date;
  final TimeOfDay time;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.time,
  });

  static Appointment fromEntity(AppointmentEntity entity) => Appointment(
        id: entity.id,
        patientId: entity.patientId,
        doctorId: entity.doctorId,
        date: entity.date,
        time: entity.time,
      );

  AppointmentEntity toEntity() => AppointmentEntity(
        id: id,
        patientId: patientId,
        doctorId: doctorId,
        date: date,
        time: time,
      );

  @override
  String toString() => '$doctorId($id)';

  @override
  List<Object> get props => [
        id,
        patientId,
        doctorId,
        date,
        time,
      ];
}
