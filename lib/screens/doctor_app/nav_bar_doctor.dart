import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/doctor_app/doctor_profile_screen.dart';
import 'package:medical_application/screens/doctor_app/my_appointments_screen.dart';
import 'package:medical_application/screens/doctor_app/profile_screen.dart';
import 'package:medical_application/screens/doctor_app/program.dart';

import 'doctor_reviews_screen.dart';

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
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorProgramScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Appointments'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyAppointmentsDoctor(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.reviews),
                title: const Text('Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorReviewsScreen(),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.medical_information),
                title: const Text('My Doctor Details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileForDoctorScreen(),
                    ),
                  );
                },
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              const Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  FirebaseAuth.instance.signOut();
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
