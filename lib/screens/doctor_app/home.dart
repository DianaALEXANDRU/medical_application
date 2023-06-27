import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/components/doctor/appointment_box_doctor.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/screens/doctor_app/nav_bar_doctor.dart';
import 'package:medical_application/utill/helpers.dart';

import '../../bloc/medical_bloc.dart';

import '../../models/constants.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  int appNumber = 0;
  List<Appointment> todayAppointments = [];

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
              todayAppointments =
                  todaysAppointments(medicalState.appointmentsByDoctor);
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
                        context.go("/doctorHome/myProfile");
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
                        top: 24,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (todayAppointments.length > 1)
                                Container(
                                  width: size.width * 0.9,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    ' You have ${todayAppointments.length} appointments today:',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              if (todayAppointments.length == 1)
                                Container(
                                  width: size.width * 0.9,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    ' You have ${todayAppointments.length} appointment today:',
                                    style: const TextStyle(
                                      color: Color(0xff363636),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                    if (todayAppointments.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: todayAppointments.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Container(
                            margin: EdgeInsets.only(
                              left: size.width * 0.05,
                              right: size.width * 0.05,
                              bottom: 10,
                            ),
                            child: AppointmentBoxDoctor(
                              size: size,
                              app: todayAppointments[index],
                              disable: false,
                              confirme: todayAppointments[index].confirmed,
                            ),
                          ),
                        ),
                      ),
                    if (todayAppointments.isEmpty)
                      Card(
                        elevation: 6,
                        child: SizedBox(
                          height: size.height * 0.65,
                          width: size.width * 0.9,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    ' You have 0 appointment today,',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: myConstants.primaryColor,
                                      // fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    ' your schedule is free ! ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: myConstants.primaryColor,
                                      // fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.asset(
                                    'assets/images/calendar.png',
                                    width: size.width / 3,
                                    height: size.height / 6,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    ' What do you whant to do next? ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: myConstants.primaryColor,
                                      // fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context.go("/doctorHome/program");

                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: myConstants.primaryColor),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.view_list_rounded,
                                  color: myConstants.primaryColor,
                                ),
                                label: const Text(
                                  'View Program',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context.go("/doctorHome/appointments");

                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: myConstants.primaryColor),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.view_list_rounded,
                                  color: myConstants.primaryColor,
                                ),
                                label: const Text(
                                  'View other appointments',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              OutlinedButton.icon(
                                onPressed: () {
                                  context.go("/doctorHome/reviews");

                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: myConstants.primaryColor),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.view_list_rounded,
                                  color: myConstants.primaryColor,
                                ),
                                label: const Text(
                                  'View Reviews',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
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
