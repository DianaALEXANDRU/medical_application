part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserClass? user;
  final Doctor? doctor;
  final bool loading;

  const AuthState({
    this.user,
    this.doctor,
    required this.loading,
  });

  AuthState copyWith({
    UserClass? user,
    Doctor? doctor,
    bool? loading,
  }) {
    return AuthState(
      user: user ?? this.user,
      doctor: doctor ?? this.doctor,
      loading: loading ?? this.loading,
    );
  }

  @override
  String toString() => 'AuthState($user)';

  @override
  List<Object?> get props => [
        user,
        doctor,
        loading,
      ];
}
