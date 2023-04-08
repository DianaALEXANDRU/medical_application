import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/utill/DBHelper.dart';
import 'package:medical_application/utill/helpers.dart';
import 'package:medical_application/utill/utillity.dart';

class AppointmentBoxWidget extends StatelessWidget {
  final Appointment appointment;
  final Size size;
  final bool disable;

  const AppointmentBoxWidget(
      {Key? key,
      required this.appointment,
      required this.size,
      required this.disable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    var doctor = findDoctorById(
      getIt<MedicalBloc>().state.doctors,
      appointment.doctorId,
    );
    return Container(
      height: size.height * 0.20,
      width: size.width * 0.8,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: myConstants.primaryColor.withOpacity(.4),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
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
                                  .format(appointment.dateAndTime),
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
                              Utility.extractTime(appointment.dateAndTime),
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
                              'Doctor:',
                              style: TextStyle(
                                color: Color(0xffababab),
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            if (doctor != null)
                              Text(
                                '${doctor.firstName} ${doctor.lastName}',
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
                          child: ElevatedButton(
                            onPressed: disable == true
                                ? null
                                : () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            child: AlertDialog(
                                              title: const Text(
                                                  'Cancel Appointment'),
                                              content: const Text(
                                                  'Are you sure you want to cancel your appointment?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    DBHelper.deleteAppointment(
                                                        appointment.id);
                                                    getIt<MedicalBloc>().add(
                                                      FetchAppointmentsForUser(
                                                          userId:
                                                              getIt<AuthBloc>()
                                                                  .state
                                                                  .user!
                                                                  .id),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                              elevation: 4.0,
                                            ),
                                          );
                                        });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                            ),
                            child: const Text(
                              'Cancel',
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
