import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/entities/appointment_hours_entity.dart';
import 'package:meta/meta.dart';

@immutable
class AppointmentHours extends Equatable {
  final String id;
  final String startHour;
  final String endHour;

  const AppointmentHours({
    required this.id,
    required this.startHour,
    required this.endHour,
  });

  static AppointmentHours fromEntity(AppointmentHoursEntity entity) =>
      AppointmentHours(
        id: entity.id,
        startHour: entity.startHour,
        endHour: entity.endHour,
      );

  AppointmentHoursEntity toEntity() => AppointmentHoursEntity(
        id: id,
        startHour: startHour,
        endHour: endHour,
      );

  @override
  String toString() => '$id($id)';

  @override
  List<Object> get props => [
        id,
        startHour,
        endHour,
      ];
}
