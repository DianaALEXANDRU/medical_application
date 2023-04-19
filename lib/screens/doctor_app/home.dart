import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/screens/doctor_app/nav_bar_doctor.dart';
import 'package:medical_application/screens/doctor_app/profile_screen.dart';

import '../../bloc/medical_bloc.dart';

import '../../models/constants.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    return BlocBuilder<AuthBloc, AuthState>(
        bloc: getIt<AuthBloc>(),
        builder: (context, authState) {
          return BlocBuilder<MedicalBloc, MedicalState>(
            bloc: getIt<MedicalBloc>(),
            builder: (context, medicalState) {
              return Scaffold(
                drawer: const NavBarDoctor(),
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: myConstants.primaryColor,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfileForDoctorScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        top: size.width * 0.05,
                        right: size.width * 0.05,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          if (authState.user != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Dr. ${authState.user!.firstName} ${authState.user!.lastName}!',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
