import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/utill/helpers.dart';

class AppointmentBoxDoctor extends StatelessWidget {
  final Size size;
  final Appointment app;
  final bool disable;
  final bool confirme;

  const AppointmentBoxDoctor({
    Key? key,
    required this.size,
    required this.app,
    required this.disable,
    required this.confirme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserClass? patient = findUserById(app.patientId);
    return Card(
      elevation: 6,
      child: SizedBox(
        height: 230,
        width: 328,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Date:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(app.dateAndTime),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 216, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Time:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                DateFormat('HH:mm').format(app.dateAndTime),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Patient:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '${patient!.firstName} ${patient.lastName}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: ElevatedButton(
                            onPressed: confirme == true
                                ? null
                                : () {
                                    getIt<MedicalBloc>().add(
                                        ConfirmeAppointment(
                                            appointmentId: app.id));
                                    getIt<MedicalBloc>().add(
                                        FetchAppointmentsForDoctor(
                                            userId: app.doctorId));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Confirm',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 216, top: 24),
                          child: ElevatedButton(
                            onPressed: disable == true
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AlertDialog(
                                          content: Text(
                                              "Ask the administrator to cancel the appointment."),
                                        );
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                            ),
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
