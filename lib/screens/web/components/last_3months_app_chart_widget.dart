import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/appointment.dart';

class Last3MonthsAppChartWidget extends StatefulWidget {
  const Last3MonthsAppChartWidget({Key? key}) : super(key: key);

  @override
  State<Last3MonthsAppChartWidget> createState() =>
      _Last3MonthsAppChartWidgetState();
}

class _Last3MonthsAppChartWidgetState extends State<Last3MonthsAppChartWidget> {
  TooltipBehavior? _tooltipBehavior;

  List<ChartMonthlyData> appointmentsInLast3Months(List<Appointment> allApp) {
    List<ChartMonthlyData> appInMonths = [];
    final currentDate = DateTime.now();
    final currentMonth = currentDate.month;
    final currentYear = currentDate.year;

    // Generate the last three months including the current month
    for (var i = 2; i >= 0; i--) {
      var month = currentMonth - i;
      var year = currentYear;

      if (month < 1) {
        month += 12;
        year--;
      }
      final monthDateTime = DateTime(year, month, 1);
      var appNr = getAppByDate(allApp, monthDateTime);
      ChartMonthlyData data = ChartMonthlyData(
          DateFormat('MMMM yyyy').format(monthDateTime), appNr);
      appInMonths.add(data);
    }

    return appInMonths;
  }

  int getAppByDate(List<Appointment> allApp, DateTime date) {
    var results = 0;

    for (var app in allApp) {
      if (app.confirmed == true &&
          DateFormat('MMMM yyyy').format(app.dateAndTime) ==
              DateFormat('MMMM yyyy').format(date)) {
        results++;
      }
    }
    return results;
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        canShowMarker: false,
        header: '',
        format: 'point.y appointments for point.x');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartMonthlyData> data = [];

    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        data = appointmentsInLast3Months(medicalState.appointments);
        var maxValue = data.map((e) => e.appNumber).reduce(max) as double?;

        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          legend: Legend(isVisible: true),
          primaryXAxis:
              CategoryAxis(majorGridLines: const MajorGridLines(width: 0)),
          primaryYAxis: NumericAxis(
              isVisible: false,
              minimum: 0,
              maximum: maxValue,
              axisLine: const AxisLine(width: 0),
              majorGridLines: const MajorGridLines(width: 0),
              majorTickLines: const MajorTickLines(size: 0)),
          series: _getTracker(data),
          tooltipBehavior: _tooltipBehavior,
        );
      },
    );
  }
}

List<ColumnSeries<ChartMonthlyData, String>> _getTracker(
    List<ChartMonthlyData> data) {
  return <ColumnSeries<ChartMonthlyData, String>>[
    ColumnSeries<ChartMonthlyData, String>(
        width: 0.3,
        dataSource: data,
        isTrackVisible: true,
        trackColor: const Color.fromRGBO(247, 251, 254, 1),
        color: Colors.green.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
        xValueMapper: (ChartMonthlyData sales, _) => sales.month,
        yValueMapper: (ChartMonthlyData sales, _) => sales.appNumber,
        name: 'Appointments',
        dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top,
            textStyle: TextStyle(fontSize: 10, color: Colors.white))),
  ];
}

class ChartMonthlyData {
  ChartMonthlyData(this.month, this.appNumber);

  final String month;
  final int appNumber;
}
