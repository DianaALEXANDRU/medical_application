import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/user_entity.dart';
import 'package:meta/meta.dart';

@immutable
class UserClass extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String role;

  const UserClass({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.role,
  });

  static UserClass fromEntity(UserEntity entity) => UserClass(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        phoneNo: entity.phoneNo,
        role: entity.role,
      );

  UserEntity toEntity() => UserEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        phoneNo: phoneNo,
        role: role,
      );

  @override
  String toString() => '$firstName($id)';

  @override
  List<Object> get props => [id, firstName, lastName, phoneNo, role];
}
