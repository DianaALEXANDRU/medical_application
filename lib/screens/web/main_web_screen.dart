import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';


class MainWebScreen extends StatefulWidget {
  const MainWebScreen({Key? key}) : super(key: key);

  @override
  State<MainWebScreen> createState() => _MainWebScreenState();
}

class _MainWebScreenState extends State<MainWebScreen> {
  @override
  void initState() {
    super.initState();
    getIt<AuthBloc>().add(const FetchUser());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {

            return (oldState.loading &&
                !newState.loading &&
                newState.user == null);
          },
          listener: (context, state) async {
            GoRouter.of(context).go("/loginWeb");
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {


            return (oldState.user != newState.user);
          },
          listener: (context, state) async {
            final role = getIt<AuthBloc>().state.user?.role;

            if (role == 'administrator') {

              getIt<MedicalBloc>().add(
                const FetchReviews(),
              );

              GoRouter.of(context).go("/dashboard");
              return;
            }

            GoRouter.of(context).go("/loginWeb");
          },
        ),
      ],
      child: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            return Container(
              color: Colors.white,
              height: size.height,
              width: size.width,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/images/log.png'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
