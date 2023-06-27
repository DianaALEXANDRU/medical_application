import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppByCategoryChartWidget extends StatefulWidget {
  const AppByCategoryChartWidget({Key? key}) : super(key: key);

  @override
  State<AppByCategoryChartWidget> createState() =>
      _AppByCategoryChartWidgetState();
}

class _AppByCategoryChartWidgetState extends State<AppByCategoryChartWidget> {
  //_AppByCategoryChartWidgetState();

  TooltipBehavior? _tooltipBehavior;

  List<ChartSampleData> getData(
      List<Category> allCat, List<Doctor> allDoc, List<Appointment> allApp) {
    List<ChartSampleData> data = [];
    for (var cat in allCat) {
      var docs = getDoctorsByCategory(allDoc, cat.name);
      var appNr = 0;
      for (var d in docs) {
        appNr = appNr + getNrAppByDoctor(allApp, d.id);
      }
      ChartSampleData chartData = ChartSampleData(cat.name, appNr);
      data.add(chartData);
    }
    return data;
  }

  int getNrAppByDoctor(List<Appointment> allApp, String doctorId) {
    int nr = 0;
    for (var app in allApp) {
      if (app.doctorId == doctorId && app.confirmed) {
        nr++;
      }
    }
    return nr;
  }

  List<Doctor> getDoctorsByCategory(List<Doctor> allDoc, String category) {
    List<Doctor> doctorByCat = [];
    for (var doc in allDoc) {
      if (doc.category == category) {
        doctorByCat.add(doc);
      }
    }
    return doctorByCat;
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

  List<ChartSampleData> data = [];

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        data = getData(medicalState.categories, medicalState.doctors,
            medicalState.appointments);

        if (data.isNotEmpty) {
          var maxValue = data.map((e) => e.y).reduce(max) as double?;
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
        } else {
          return const Text('No data yet.');
        }
        //Text('');
      },
    );
  }

  /// Get column series with tracker
  List<ColumnSeries<ChartSampleData, String>> _getTracker(
      List<ChartSampleData> data) {
    // data=getData(allCat,allDoc,allApp);
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: data,

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(247, 251, 254, 1),
          color: Colors.lightBlueAccent,
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartSampleData sales, _) => sales.x,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Appointments',
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.y);

  final String x;
  final int y;
}
