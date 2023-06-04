import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';

import '../../../bloc/medical_bloc.dart';

class AppointmentsChartWidget extends StatefulWidget {
  const AppointmentsChartWidget({Key? key}) : super(key: key);

  @override
  State<AppointmentsChartWidget> createState() =>
      _AppointmentsChartWidgetState();
}

class _AppointmentsChartWidgetState extends State<AppointmentsChartWidget> {
  int tapIndex = -1;

  List<AppByDate> appointmentsInLast7Days(List<Appointment> allApp) {
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

    List<AppByDate> appInDays = [];
    AppByDate d1 = AppByDate(DateFormat('dd MMM').format(day1), appDay1);
    AppByDate d2 = AppByDate(DateFormat('dd MMM').format(day2), appDay2);
    AppByDate d3 = AppByDate(DateFormat('dd MMM').format(day3), appDay3);
    AppByDate d4 = AppByDate(DateFormat('dd MMM').format(day4), appDay4);
    AppByDate d5 = AppByDate(DateFormat('dd MMM').format(day5), appDay5);
    AppByDate d6 = AppByDate(DateFormat('dd MMM').format(day6), appDay6);
    AppByDate d7 = AppByDate(DateFormat('dd MMM').format(day7), appDay7);
    appInDays.add(d1);
    appInDays.add(d2);
    appInDays.add(d3);
    appInDays.add(d4);
    appInDays.add(d5);
    appInDays.add(d6);
    appInDays.add(d7);

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

  List<AppByDate> appByDate = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        appByDate = appointmentsInLast7Days(medicalState.appointments);
        var maxValue = appByDate.map((e) => e.appNumber).reduce(max);
        return BarChart(
          BarChartData(
            // remove background grid
            gridData: FlGridData(show: false),
            // remove the borders
            borderData: FlBorderData(
              border: const Border(
                bottom: BorderSide(
                  width: 1,
                  color: Color(0xFFECECEC),
                ),
              ),
            ),
            // titles
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final spending =
                        appByDate[value.toInt()].appNumber.toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        spending,
                        style: TextStyle(
                          color: tapIndex == value.toInt()
                              ? Colors.black
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final day = appByDate[value.toInt()].day;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        day,
                        style: TextStyle(
                          color: tapIndex == value.toInt()
                              ? Colors.black
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            maxY: maxValue.toDouble(),
            barTouchData: BarTouchData(
              enabled: true,
              touchCallback: (event, response) {
                if (response != null && event is FlTapUpEvent) {
                  setState(() {
                    if (response.spot != null) {
                      tapIndex = response.spot!.touchedBarGroupIndex;
                    }
                  });
                }
              },
            ),
            barGroups: [
              for (int i = 0; i < appByDate.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: appByDate[i].appNumber.toDouble(),
                      color: const Color(0xFF17D77C),
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}

class AppByDate {
  AppByDate(this.day, this.appNumber);

  final String day;
  final int appNumber;
}
