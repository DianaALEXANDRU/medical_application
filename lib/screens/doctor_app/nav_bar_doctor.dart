import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

import '../../bloc/medical_bloc.dart';

class NavBarDoctor extends StatelessWidget {
  const NavBarDoctor({super.key});

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
                accountName: Text(
                    'Dr. ${authState.doctor!.firstName} ${authState.doctor!.lastName}'),
                accountEmail: const Text(''),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: 80,
                      height: 80,
                      imageUrl: authState.doctor!.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: myConstants.linearGradientBlue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.view_list_rounded),
                title: const Text('Program'),
                onTap: () {
                  getIt<MedicalBloc>().add(
                      FetchProgram(doctorId: authState.doctor!.id));
                  GoRouter.of(context).go("/doctorHome/program");
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Appointments'),
                onTap: () {
                  getIt<MedicalBloc>().add(
                    FetchAppointmentsForDoctor(
                        userId: authState.doctor!.id),
                  );
                  GoRouter.of(context).go("/doctorHome/appointments");
                },
              ),
              ListTile(
                leading: const Icon(Icons.reviews),
                title: const Text('Reviews'),
                onTap: () {
                  getIt<MedicalBloc>().add(
                    const FetchReviews(),
                  );
                  GoRouter.of(context).go("/doctorHome/reviews");
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.medical_information),
                title: const Text('My Doctor Details'),
                onTap: () {
                  GoRouter.of(context).go("/doctorHome/myDoctorDetails");
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  GoRouter.of(context).go("/doctorHome/myProfile");
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
