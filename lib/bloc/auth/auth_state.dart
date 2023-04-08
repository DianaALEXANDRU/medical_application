part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserClass? user;
  final Doctor? doctor;

  const AuthState({
    this.user,
    this.doctor,
  });

  AuthState copyWith({UserClass? user, Doctor? doctor}) {
    return AuthState(user: user ?? this.user, doctor: doctor ?? this.doctor);
  }

  @override
  String toString() => 'AuthState($user)';

  @override
  List<Object?> get props => [
        user,
        doctor,
      ];
}
