part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class Register extends AuthEvent {
  final String firstName;
  final String lastName;
  final String phoneNo;
  final String email;
  final String password;

  const Register({
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
    required this.email,
    required this.password,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        phoneNo,
        email,
        password,
      ];
}

class LogIn extends AuthEvent {
  final String email;
  final String password;

  const LogIn({
    required this.email,
    required this.password,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class PasswordReset extends AuthEvent {
  final String email;

  const PasswordReset({
    required this.email,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        email,
      ];
}

class FetchUser extends AuthEvent {
  const FetchUser();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchDoctor extends AuthEvent {
  const FetchDoctor();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}
