import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/entities/appointment_entity.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:meta/meta.dart';

@immutable
class Appointment extends Equatable {
  final int id;
  final String patient;
  final Doctor doctor;
  final DateTime date;

  // final String time;

  //DateFormat dateFormat = DateFormat('dd MMMM yyyy        HH:mm');

  const Appointment({
    required this.id,
    required this.patient,
    required this.doctor,
    required this.date,
    // required this.time,
  });

  static Appointment fromEntity(AppointmentEntity entity) => Appointment(
        id: entity.id,
        patient: entity.patient,
        doctor: Doctor.fromEntity(entity.doctor),
        date: DateTime.parse(entity.date + ' ' + entity.time),
        // time: entity.time,
      );

  AppointmentEntity toEntity() => AppointmentEntity(
        id: id,
        patient: patient,
        doctor: doctor.toEntity(),
        date: date.toString(),
        time: DateFormat('kk:mm').format(date).toString(),
      );

  @override
  String toString() => '$doctor($id)';

  @override
  List<Object> get props => [
        id,
        patient,
        doctor,
        date,
        //time,
      ];
}
