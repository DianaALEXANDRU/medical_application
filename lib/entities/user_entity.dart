import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldFirstName = 'first_name';
  static const String fieldLastName = 'last_name';
  static const String fieldPhoneNo = 'phone_no';
  static const String fieldRole = 'role';

  final String id;
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String role;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.role,
  });

  static UserEntity fromJson(Map<String, dynamic> json) => UserEntity(
      id: json[fieldId],
      firstName: json[fieldFirstName],
      lastName: json[fieldLastName],
      phoneNo: json[fieldPhoneNo],
      role: json[fieldRole]);

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldFirstName: firstName,
        fieldLastName: lastName,
        fieldPhoneNo: phoneNo,
        fieldRole: role,
      };

  @override
  List<Object> get props => [
        id,
        firstName,
        lastName,
        phoneNo,
        role,
      ];
}
