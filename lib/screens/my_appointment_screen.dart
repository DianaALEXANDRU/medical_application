import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/appointment_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
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
                  context.go("/patientHome");
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
                    Expanded(
                      child: upcomingAppointments.isEmpty
                          ? const Center(
                              child: Text(
                                'You have no upcoming appointments.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              itemCount: upcomingAppointments.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                child: AppointmentBoxWidget(
                                  appointment: upcomingAppointments[index],
                                  size: size,
                                  disable: false,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: pastAppointments.isEmpty
                          ? const Center(
                              child: Text(
                                'You have no past appointments.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              itemCount: pastAppointments.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => Container(
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 16,
                                ),
                                child: AppointmentBoxWidget(
                                  appointment: pastAppointments[index],
                                  size: size,
                                  disable: true,
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
