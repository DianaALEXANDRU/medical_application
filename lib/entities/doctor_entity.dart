import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DoctorEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldFirstName = 'first_name';
  static const String fieldLastName = 'last_name';
  static const String fieldPhoneNo = 'phone_no';
  static const String fieldRole = 'role';
  static const String fieldDescription = 'description';
  static const String fieldExperience = 'experience';
  static const String fieldImageUrl = 'image_url';
  static const String fieldCategory = 'category';

  final String id;
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String role;
  final String description;
  final String experience;
  final String imageUrl;
  final String category;

  const DoctorEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.role,
    required this.description,
    required this.experience,
    required this.imageUrl,
    required this.category,
  });

  static DoctorEntity fromJson(Map<String, dynamic> json) => DoctorEntity(
        id: json[fieldId],
        firstName: json[fieldFirstName],
        lastName: json[fieldLastName],
        phoneNo: json[fieldPhoneNo],
        role: json[fieldRole],
        description: json[fieldDescription] ?? '',
        experience: json[fieldExperience],
        imageUrl: json[fieldImageUrl] ?? '',
        category: json[fieldCategory] ?? '',
      );

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldFirstName: firstName,
        fieldLastName: lastName,
        fieldPhoneNo: phoneNo,
        fieldRole: role,
        fieldDescription: description,
        fieldExperience: experience,
        fieldImageUrl: imageUrl,
        fieldCategory: category,
      };

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        phoneNo,
        role,
        description,
        experience,
        imageUrl,
        category,
      ];
}
