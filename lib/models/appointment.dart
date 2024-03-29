import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/entities/appointment_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Appointment extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateAndTime;
  final bool confirmed;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateAndTime,
    required this.confirmed,
  });

  static Appointment fromEntity(AppointmentEntity entity) => Appointment(
        id: entity.id,
        patientId: entity.patientId,
        doctorId: entity.doctorId,
        dateAndTime: entity.dateAndTime,
        confirmed: entity.confirmed,
      );

  AppointmentEntity toEntity() => AppointmentEntity(
        id: id,
        patientId: patientId,
        doctorId: doctorId,
        dateAndTime: dateAndTime,
        confirmed: confirmed,
      );

  @override
  String toString() => '$doctorId($id)';

  @override
  List<Object> get props => [
        id,
        patientId,
        doctorId,
        dateAndTime,
        confirmed,
      ];
}
