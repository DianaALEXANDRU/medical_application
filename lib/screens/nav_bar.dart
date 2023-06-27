import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/models/constants.dart';


import '../bloc/auth/auth_bloc.dart';
import '../main.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: const Text(
                  'Hello,',
                  style: TextStyle(fontSize: 16),
                ),
                accountEmail:  Text(
                    '${authState.user!.firstName} ${authState.user!.lastName}!',
                  style: const TextStyle(fontSize: 15),
                ),
                decoration: BoxDecoration(
                  gradient: myConstants.linearGradientBlue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.view_list_rounded),
                title: const Text('Doctors'),
                onTap: () {
                  context.go("/patientHome/doctors/all");
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('My appointments'),
                onTap: () {
                  context.go("/patientHome/myAppointments");
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  context.go("/patientHome/myProfile");
                },
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  GoRouter.of(context).go("/login");
                },
                child: const ListTile(
                  title: Text('Exit'),
                  leading: Icon(Icons.exit_to_app),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
