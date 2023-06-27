import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';

import '../../utill/helpers.dart';
import 'components/drawer_menu.dart';
import 'doctor_profile_content_screen.dart';

class DoctorProfileWebScreen extends StatefulWidget {
  final String doctorId;

  const DoctorProfileWebScreen({Key? key, required this.doctorId})
      : super(key: key);

  @override
  State<DoctorProfileWebScreen> createState() => _DoctorProfileWebScreenState();
}

class _DoctorProfileWebScreenState extends State<DoctorProfileWebScreen> {
  @override
  Widget build(BuildContext context) {
    Doctor doctor = const Doctor(
        id: '',
        firstName: '',
        lastName: '',
        phoneNo: '',
        role: '',
        email: '',
        description: '',
        experience: '',
        imageUrl: '',
        category: '',
        available: true,);
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        if (findDoctor(medicalState.doctors, widget.doctorId) != null) {
          doctor = findDoctor(medicalState.doctors, widget.doctorId)!;
        }
        return Scaffold(
          backgroundColor: const Color.fromRGBO(247, 251, 254, 1),
          drawer: const DrawerMenu(),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Expanded(
                    child: DrawerMenu(),
                  ),
                Expanded(
                  flex: 5,
                  child: DoctorProfileContentScreen(doctor: doctor),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
