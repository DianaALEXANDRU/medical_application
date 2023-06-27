import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../bloc/medical_bloc.dart';
import '../../../main.dart';
import '../../../models/category.dart';
import '../../../models/doctor.dart';

class DocByCatChartWidget extends StatefulWidget {
  const DocByCatChartWidget({Key? key}) : super(key: key);

  @override
  State<DocByCatChartWidget> createState() => _DocByCatChartWidgetState();
}

class _DocByCatChartWidgetState extends State<DocByCatChartWidget> {
  late TooltipBehavior _tooltipBehavior;

  int docNumberByCategory(List<Doctor> allDoc, String category) {
    int nr = 0;
    for (var doc in allDoc) {
      if (doc.category == category) {
        nr++;
      }
    }
    return nr;
  }

  List<DocByCategoryData> data(List<Doctor> allDoc, List<Category> allCat) {
    List<DocByCategoryData> dataList = [];

    for (var cat in allCat) {
      int nr = docNumberByCategory(allDoc, cat.name);
      DocByCategoryData doc = DocByCategoryData(cat.name, nr);
      dataList.add(doc);
    }
    return dataList;
  }

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DocByCategoryData> dataList = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        dataList = data(medicalState.doctors, medicalState.categories);
        return SfCircularChart(
          legend: Legend(
              isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          tooltipBehavior: _tooltipBehavior,
          series: <CircularSeries>[
            PieSeries<DocByCategoryData, String>(
              dataSource: dataList,
              xValueMapper: (DocByCategoryData data, _) =>
                  '${data.categoryName}: ${data.doctorNumber}',
              yValueMapper: (DocByCategoryData data, _) => data.doctorNumber,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              enableTooltip: true,
            )
          ],
        );
      },
    );
  }
}

class DocByCategoryData {
  DocByCategoryData(this.categoryName, this.doctorNumber);

  final String categoryName;
  final int doctorNumber;
}
