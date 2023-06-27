import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          const AuthState(loading: false),
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


    emit(
      state.copyWith(
        loading: true,
      ),
    );

    UserClass? user = await authRepository.fetchUser();



    emit(
      state.copyWith(
        user: user,
      ),
    );

    if (user?.role == 'doctor') {
      Doctor doctor = await authRepository.fetchDoctor();
      emit(
        state.copyWith(
          doctor: doctor,
        ),
      );
    }

    emit(
      state.copyWith(
        loading: false,
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

    try{
      await authRepository.register(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNo: event.phoneNo,
        email: event.email,
        password: event.password,
      );


      add(const FetchUser());

    }on FirebaseAuthException catch (e){

      String error='';

      if (e.code == 'email-already-in-use') {
        error = 'This email address  is already associated with an existing account';
      }  else {
        error='An error happened during log in process.';
      }

      emit(
        state.copyWith(
          errorMessage: error,
        ),
      );
    }

  }

  Future<void> _handleLogIn(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    String error = '';

    try {
      await authRepository.logIn(
        email: event.email,
        password: event.password,
      );
      //

      add(const FetchUser());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        error = 'Email address is not valid.';
      }else {
        error='An error happened during log in process.';
      }

      emit(
        state.copyWith(
          errorMessage: error,
        ),
      );
    }
  }

  Future<void> _handlePasswordReset(
    PasswordReset event,
    Emitter<AuthState> emit,
  ) async {

    try{

      await authRepository.passwordReset(
        email: event.email,
      );

    } on FirebaseAuthException catch (e){

      String error='';

      if (e.code == 'user-not-found') {

        error = 'No user found for that email.';


      } else if (e.code == 'too-many-requests') {
        error = 'Too many password reset attempts from the same IP address or device in a short period.';


      } else if (e.code == 'invalid-email') {
        error = 'Email address is not valid.';


      }else {
        error='An error happened during log in process.';
      }

      emit(
        state.copyWith(
          errorMessage: error,
        ),
      );

    }
  }
}
