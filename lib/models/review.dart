import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/entities/review_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Review extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime dateAndTime;
  final String comment;
  final int stars;

  const Review({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateAndTime,
    required this.comment,
    required this.stars,
  });

  static Review fromEntity(ReviewEntity entity) => Review(
        id: entity.id,
        patientId: entity.patientId,
        doctorId: entity.doctorId,
        dateAndTime: entity.dateAndTime,
        comment: entity.comment,
        stars: entity.stars,
      );

  ReviewEntity toEntity() => ReviewEntity(
        id: id,
        patientId: patientId,
        doctorId: doctorId,
        dateAndTime: dateAndTime,
        comment: comment,
        stars: stars,
      );

  @override
  String toString() => '$doctorId($id)';

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
