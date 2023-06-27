import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/screens/web/components/radial_painter.dart';
import 'package:medical_application/utill/helpers.dart';


class TodaysCompletedAppointmentsWidget extends StatelessWidget {
  const TodaysCompletedAppointmentsWidget({Key? key}) : super(key: key);

  double todaysAppProcentage(double confirmedApp, double todaysApp) {
    if (confirmedApp == 0 || todaysApp == 0) return 0.0;

    return (100 * confirmedApp) / todaysApp;
  }

  double todaysConfirmed(List<Appointment> todaysApp) {
    var confirmedApp = 0.0;
    for (var a in todaysApp) {
      if (a.confirmed) {
        confirmedApp++;
      }
    }
    return confirmedApp;
  }

  int getAppByDate(List<Appointment> allApp, DateTime date) {
    var results = 0;

    for (var app in allApp) {
      if (app.confirmed == true &&
          DateFormat("dd/MM/yyyy").format(app.dateAndTime) ==
              DateFormat("dd/MM/yyyy").format(date)) {
        results++;
      }
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {

    List<Appointment> todaysApps = [];
    double confirmedApp = 0.0;
    double appProcentage = 0.0;

    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        todaysApps = todaysAppointments(medicalState.appointments);
        confirmedApp = todaysConfirmed(todaysApps);
        appProcentage =
            todaysAppProcentage(confirmedApp, todaysApps.length.toDouble());

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today`s appointments',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  height: 230,
                  child: CustomPaint(
                    foregroundPainter: RadialPainter(
                      bgColor: Colors.green.withOpacity(0.1),
                      lineColor: Colors.lightBlue,
                      percent: appProcentage / 100,
                      width: 18.0,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (todaysApps.isNotEmpty)
                            Text(
                              '$appProcentage%',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (todaysApps.isNotEmpty)
                            Text(
                              '$confirmedApp/${todaysAppointments(medicalState.appointments).length}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (todaysApps.isEmpty)
                            const Text(
                              'No appointments',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Colors.lightBlue,
                            size: 10,
                          ),
                          const SizedBox(
                            width: 16 / 2,
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.black54.withOpacity(0.5),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green.withOpacity(0.2),
                            size: 10,
                          ),
                          const SizedBox(
                            width: 24 / 2,
                          ),
                          const Text(
                            'Uncompleted',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
