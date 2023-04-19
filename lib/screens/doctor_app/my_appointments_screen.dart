import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/doctor/appointment_box_doctor.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/utill/utillity.dart';

class MyAppointmentsDoctor extends StatefulWidget {
  const MyAppointmentsDoctor({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsDoctor> createState() => _MyAppointmentsDoctorState();
}

class _MyAppointmentsDoctorState extends State<MyAppointmentsDoctor> {
  @override
  void initState() {
    super.initState();
  }

  List<Appointment> _runFilterUpcoming(List<Appointment> allAppointments) {
    List<Appointment> results = [];

    results = allAppointments
        .where((appointment) => appointment.dateAndTime.isAfter(DateTime.now()))
        .toList();

    return results;
  }

  List<Appointment> _runFilterPast(List<Appointment> allAppointments) {
    List<Appointment> results = [];

    results = allAppointments
        .where(
            (appointment) => appointment.dateAndTime.isBefore(DateTime.now()))
        .toList();

    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Appointment> upcomingAppointments = [];
    List<Appointment> pastAppointments = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        upcomingAppointments = _runFilterUpcoming(medicalState.appointments);
        pastAppointments = _runFilterPast(medicalState.appointments);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                'My Appointments',
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              bottom: const TabBar(
                indicatorColor: Color(0xff38B6FF),
                indicatorWeight: 5,
                labelColor: Colors.black,
                tabs: [
                  Tab(
                    text: 'Upcoming',
                  ),
                  Tab(
                    text: 'Past',
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: upcomingAppointments.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            children: [
                              if (index == 0 ||
                                  (index > 0 &&
                                      Utility.compareDates(
                                              upcomingAppointments[index - 1]
                                                  .dateAndTime,
                                              upcomingAppointments[index]
                                                  .dateAndTime) ==
                                          false))
                                Text(
                                  '${DateFormat.EEEE().format(
                                    upcomingAppointments[index].dateAndTime,
                                  )} ${DateFormat('dd/MM/yyyy').format(
                                    upcomingAppointments[index].dateAndTime,
                                  )}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              AppointmentBoxDoctor(
                                  app: upcomingAppointments[index],
                                  size: size,
                                  disable: false,
                                  confirme:
                                      upcomingAppointments[index].confirmed),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: pastAppointments.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Column(
                            children: [
                              if (index == 0 ||
                                  (index > 0 &&
                                      Utility.compareDates(
                                              pastAppointments[index - 1]
                                                  .dateAndTime,
                                              pastAppointments[index]
                                                  .dateAndTime) ==
                                          false))
                                Text(
                                  '${DateFormat.EEEE().format(
                                    pastAppointments[index].dateAndTime,
                                  )} ${DateFormat('dd/MM/yyyy').format(
                                    pastAppointments[index].dateAndTime,
                                  )}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              AppointmentBoxDoctor(
                                  app: pastAppointments[index],
                                  size: size,
                                  disable: true,
                                  confirme:
                                      upcomingAppointments[index].confirmed),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
