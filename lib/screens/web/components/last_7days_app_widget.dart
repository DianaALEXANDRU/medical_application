import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'chart.dart';

class Last7DaysAppointmentsWidget extends StatelessWidget {
  const Last7DaysAppointmentsWidget({Key? key}) : super(key: key);

  List<int> appointmentsInLast7Days(List<Appointment> allApp) {
    DateTime day7 = DateTime.now();
    DateTime day6 = DateTime.now().subtract(const Duration(days: 1));
    DateTime day5 = DateTime.now().subtract(const Duration(days: 2));
    DateTime day4 = DateTime.now().subtract(const Duration(days: 3));
    DateTime day3 = DateTime.now().subtract(const Duration(days: 4));
    DateTime day2 = DateTime.now().subtract(const Duration(days: 5));
    DateTime day1 = DateTime.now().subtract(const Duration(days: 6));


    var appDay1 = getAppByDate(allApp, day1);
    var appDay2 = getAppByDate(allApp, day2);
    var appDay3 = getAppByDate(allApp, day3);
    var appDay4 = getAppByDate(allApp, day4);
    var appDay5 = getAppByDate(allApp, day5);
    var appDay6 = getAppByDate(allApp, day6);
    var appDay7 = getAppByDate(allApp, day7);

    List<int> appInDays = [];
    appInDays.add(appDay1);
    appInDays.add(appDay2);
    appInDays.add(appDay3);
    appInDays.add(appDay4);
    appInDays.add(appDay5);
    appInDays.add(appDay6);
    appInDays.add(appDay7);

    return appInDays;
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
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        appointmentsInLast7Days(medicalState.appointments);
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
                  'Last 7 days completed appointments',
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
                  child: const Center(
                    child: AppointmentsChartWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
