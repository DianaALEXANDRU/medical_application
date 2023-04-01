import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/screens/auth_page.dart';
import 'package:medical_application/screens/login_screen.dart';

import 'doctor_app/home.dart';
import 'example_screen.dart';
import 'home_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listenWhen: (oldState, newState) =>
          oldState.user == null && newState.user != null,
      listener: (context, state) async {
        final role = getIt<AuthBloc>().state.user?.role;
        if (role == 'user') {
          getIt<MedicalBloc>().add(FetchAppointmentsForUser(
              userId: getIt<AuthBloc>().state.user!.id));
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
        if (role == 'doctor') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DoctorHome(),
            ),
          );
        }
      },
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              getIt<AuthBloc>().add(const FetchUser());
            }
            return const AuthPage();
          },
        ),
      ),
    );
  }
}
