import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Doctor extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String role;
  final String email;
  final String description;
  final String experience;
  final String imageUrl;
  final String category;

  const Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.role,
    required this.email,
    required this.description,
    required this.experience,
    required this.imageUrl,
    required this.category,
  });

  static Doctor fromEntity(DoctorEntity entity) => Doctor(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phoneNo: entity.phoneNo,
        role: entity.role,
        email: entity.email,
        description: entity.description,
        experience: entity.experience,
        imageUrl: entity.imageUrl,
        category: entity.category,
      );

  DoctorEntity toEntity() => DoctorEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phoneNo: phoneNo,
        role: role,
        email: email,
        description: description,
        experience: experience,
        imageUrl: imageUrl,
        category: category,
      );

  @override
  String toString() => '$firstName($id)';

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        phoneNo,
        role,
        email,
        description,
        experience,
        imageUrl,
        category,
      ];
}
