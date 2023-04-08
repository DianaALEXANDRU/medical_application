import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medical_application/models/doctor.dart';
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
          const AuthState(),
        ) {
    on<Register>(_handleRegister);
    on<LogIn>(_handleLogIn);
    on<PasswordReset>(_handlePasswordReset);
    on<FetchUser>(_handleFetchUser);
    on<FetchDoctor>(_handleFetchDoctor);
  }

  Future<void> _handleFetchUser(
    FetchUser event,
    Emitter<AuthState> emit,
  ) async {
    UserClass user = await authRepository.fetchUser();
    if (user.role == 'doctor') {
      Doctor doctor = await authRepository.fetchDoctor();
      emit(
        state.copyWith(
          doctor: doctor,
        ),
      );
    }
    emit(
      state.copyWith(
        user: user,
      ),
    );
  }

  Future<void> _handleFetchDoctor(
    FetchDoctor event,
    Emitter<AuthState> emit,
  ) async {
    Doctor doctor = await authRepository.fetchDoctor();
    emit(
      state.copyWith(
        doctor: doctor,
      ),
    );
  }

  Future<void> _handleRegister(
    Register event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.register(
      firstName: event.firstName,
      lastName: event.lastName,
      phoneNo: event.phoneNo,
      email: event.email,
      password: event.password,
    );

    UserClass user = await authRepository.fetchUser();
    emit(
      state.copyWith(
        user: user,
      ),
    );
  }

  Future<void> _handleLogIn(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.logIn(
      email: event.email,
      password: event.password,
    );

    UserClass user = await authRepository.fetchUser();
    emit(
      state.copyWith(
        user: user,
      ),
    );
  }

  Future<void> _handlePasswordReset(
    PasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    authRepository.passwordReset(
      email: event.email,
    );
  }
}
