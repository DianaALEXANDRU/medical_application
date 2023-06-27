import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../bloc/medical_bloc.dart';
import '../../../main.dart';
import '../../../models/doctor.dart';
import '../../../models/review.dart';

class DoctorRatingsChartWidget extends StatefulWidget {
  const DoctorRatingsChartWidget({Key? key}) : super(key: key);

  @override
  State<DoctorRatingsChartWidget> createState() =>
      _DoctorRatingsChartWidgetState();
}

class _DoctorRatingsChartWidgetState extends State<DoctorRatingsChartWidget> {
  TooltipBehavior? _tooltipBehavior;

  List<ChartSampleData> getData(List<Doctor> allDoc, List<Review> allReviews) {
    List<ChartSampleData> data = [];
    for (var doc in allDoc) {
      var rating = ratingByDoctor(doc.id, allReviews);
      ChartSampleData ratingData =
          ChartSampleData('${doc.firstName} ${doc.lastName}', rating);
      data.add(ratingData);
    }
    data.sort((a, b) => a.y.compareTo(b.y));

    return data;
  }

  double ratingByDoctor(String doctorId, List<Review> allReviews) {
    double rating = 0.0;
    double sum = 0.0;
    double nr = 0.0;
    for (var r in allReviews) {
      if (r.doctorId == doctorId) {
        sum = sum + r.stars.toDouble();
        nr = nr + 1;
      }
    }
    if (sum != 0.0) {
      rating = sum / nr;
    }
    String inString = rating.toStringAsFixed(2);
    double inDouble = double.parse(inString);
    return inDouble;
  }

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ChartSampleData> data = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        data = getData(medicalState.doctors, medicalState.reviews);
        return SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              title: AxisTitle(text: 'Rating'),
              minimum: 0,
              maximum: 5,
              majorTickLines: const MajorTickLines(size: 0)),
          series: _getTrackerBarSeries(data),
          tooltipBehavior: _tooltipBehavior,
        );
      },
    );
  }

  List<BarSeries<ChartSampleData, String>> _getTrackerBarSeries(
      List<ChartSampleData> data) {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: data,
        borderRadius: BorderRadius.circular(15),
        trackColor: const Color.fromRGBO(247, 251, 254, 1),
        color: Colors.lightGreen.withOpacity(0.6),
        isTrackVisible: true,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        xValueMapper: (ChartSampleData sales, _) => sales.x,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}

class ChartSampleData {
  ChartSampleData(this.x, this.y);

  final String x;
  final double y;
}
