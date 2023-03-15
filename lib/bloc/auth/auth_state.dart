part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final UserClass? user;

  const AuthState({
    this.user,
  });

  AuthState copyWith({
    UserClass? user,
  }) {
    return AuthState(
      user: user ?? this.user,
    );
  }

  @override
  String toString() => 'AuthState($user)';

  @override
  List<Object?> get props => [
        user,
      ];
}
