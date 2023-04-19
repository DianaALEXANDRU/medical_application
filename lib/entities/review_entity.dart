import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class ReviewEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldPatientId = 'patient_id';
  static const String fieldDoctorId = 'doctor_id';
  static const String fieldDate = 'date_and_time';
  static const String fieldComment = 'comment';
  static const String fieldStars = 'stars';

  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateAndTime;
  final String comment;
  final int stars;

  const ReviewEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateAndTime,
    required this.comment,
    required this.stars,
  });

  static ReviewEntity fromJson(Map<String, dynamic> json) => ReviewEntity(
        id: json[fieldId],
        patientId: json[fieldPatientId],
        doctorId: json[fieldDoctorId],
        dateAndTime: DateTime.parse(json[fieldDate]),
        comment: json[fieldComment],
        stars: json[fieldStars],
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldPatientId: patientId,
        fieldDoctorId: doctorId,
        fieldDate: dateAndTime,
        fieldComment: comment,
        fieldStars: stars,
      };

  @override
  List<Object> get props => [
        id,
        patientId,
        doctorId,
        dateAndTime,
        comment,
        stars,
      ];
}
