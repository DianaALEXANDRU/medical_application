import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/repositories/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({
    required this.authRepository,
  }) : super(
          AuthState(),
        ) {
    on<Register>(_handleRegister);
    on<LogIn>(_handleLogIn);
    on<PasswordReset>(_handlePasswordReset);
  }

  Future<void> _handleRegister(
    Register event,
    Emitter<AuthState> emit,
  ) async {
    authRepository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      phoneNo: event.phoneNo,
      email: event.email,
      password: event.password,
    );

    //TODO emit user

    UserClass user = await authRepository.fetchUser();
    emit(
      state.copyWith(
        user: user,
      ),
    );
    print('#############INbloc ${user}');
  }

  Future<void> _handleLogIn(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    authRepository.logIn(
      email: event.email,
      password: event.password,
    );

    //TODO emit user
    UserClass user = await authRepository.fetchUser();
    emit(
      state.copyWith(
        user: user,
      ),
    );
    print('#############INbloc ${user}');
  }

  Future<void> _handlePasswordReset(
    PasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    authRepository.passwordReset(
      email: event.email,
    );

    //TODO emit user
  }
}
