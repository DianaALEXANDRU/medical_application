import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DoctorEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldFirstName = 'first_name';
  static const String fieldLastName = 'last_name';
  static const String fieldPhoneNo = 'phone_no';
  static const String fieldRole = 'role';
  static const String fieldEmail = 'email';
  static const String fieldDescription = 'description';
  static const String fieldExperience = 'experience';
  static const String fieldImageUrl = 'image_url';
  static const String fieldCategory = 'category';
  static const String fieldAvailable='available';

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
  final bool available;

  const DoctorEntity({
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
    required this.available,
  });

  static DoctorEntity fromJson(Map<String, dynamic> json) => DoctorEntity(
        id: json[fieldId],
        firstName: json[fieldFirstName],
        lastName: json[fieldLastName],
        phoneNo: json[fieldPhoneNo],
        role: json[fieldRole],
        email: json[fieldEmail],
        description: json[fieldDescription] ?? '',
        experience: json[fieldExperience],
        imageUrl: json[fieldImageUrl] ?? '',
        category: json[fieldCategory] ?? '',
        available:json[fieldAvailable]?? '',
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldFirstName: firstName,
        fieldLastName: lastName,
        fieldPhoneNo: phoneNo,
        fieldRole: role,
        fieldEmail: email,
        fieldDescription: description,
        fieldExperience: experience,
        fieldImageUrl: imageUrl,
        fieldCategory: category,
        fieldAvailable: available,
      };

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
        available,
      ];
}
