part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserClass? user;
  final Doctor? doctor;
  final bool loading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.doctor,
    required this.loading,
    this.errorMessage,
  });

  AuthState copyWith({
    UserClass? user,
    Doctor? doctor,
    bool? loading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      doctor: doctor ?? this.doctor,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() => 'AuthState($user)';

  @override
  List<Object?> get props => [
        user,
        doctor,
        loading,
        errorMessage,
      ];
}
