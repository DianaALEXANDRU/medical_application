import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/appointment_box.dart';
import 'package:medical_application/main.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
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
                Expanded(
                    child: ListView.builder(
                        itemCount: medicalState.appointments.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: appointment_box(
                                dateTime: DateTime.now(),
                                appointment: medicalState.appointments[index],
                                size: size,
                              ),
                            ))),

                //todo tab old appointment
                Expanded(
                    child: ListView.builder(
                        itemCount: medicalState.appointments.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 16,
                              ),
                              child: appointment_box(
                                dateTime: DateTime.now(),
                                appointment: medicalState.appointments[index],
                                size: size,
                              ),
                            ))),
              ],
            ),
          ),
        );
      },
    );
  }
}
