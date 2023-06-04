import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';

import 'doctor_app/home.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    getIt<AuthBloc>().add(const FetchUser());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {
            print(
                "############# ${oldState.loading} ### ${newState.loading} ### ${newState.user} ");
            return (oldState.loading &&
                !newState.loading &&
                newState.user == null);
          },
          listener: (context, state) async {
            GoRouter.of(context).go("/login");
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {
            print(
                "################################### ${GoRouter.of(context).location} ");

            return (oldState.user != newState.user);
          },
          listener: (context, state) async {
            final role = getIt<AuthBloc>().state.user?.role;

            if (role == 'user') {
              getIt<MedicalBloc>().add(
                FetchAppointmentsForUser(
                    userId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                const FetchReviews(),
              );

              GoRouter.of(context).go("/patientHome");
              return;
            }
            if (role == 'doctor') {
              getIt<MedicalBloc>().add(
                FetchAppointmentsForDoctor(
                    userId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                const FetchUsers(),
              );
              getIt<MedicalBloc>().add(
                FetchReviewsByDoctorId(
                    doctorId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                  FetchProgram(doctorId: getIt<AuthBloc>().state.user!.id));

              GoRouter.of(context).go("/doctorHome");
              return;
            }
            GoRouter.of(context).go("/login");
          },
        ),
      ],
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //if (snapshot.hasData) {
            // }

            return Container(
              color: Colors.blue,
              height: 400,
              width: 200,
            );
          },
        ),
      ),
    );
  }
}
