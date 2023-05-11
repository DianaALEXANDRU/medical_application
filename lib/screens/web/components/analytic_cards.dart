import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';

import '../responsive_widget.dart';
import 'analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ResponsiveWidget(
      smallScreen: AnalyticInfoCardGridView(
        crossAxisCount: size.width < 650 ? 2 : 4,
        childAspectRatio: size.width < 650 ? 2 : 1.5,
      ),
      largeScreen: AnalyticInfoCardGridView(
        childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatelessWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: childAspectRatio,
      children: <Widget>[
        AnalyticInfoCard(
          info: "Doctors",
          infoImage: 'assets/images/doctors.png',
          infoColor: myConstants.primaryColor,
          infoValue: 10,
        ),
        AnalyticInfoCard(
          info: "Patients",
          infoImage: 'assets/images/patient.png',
          infoColor: myConstants.primaryColor,
          infoValue: 43,
        ),
        AnalyticInfoCard(
          info: "Appointments",
          infoImage: 'assets/images/appointment.png',
          infoColor: myConstants.primaryColor,
          infoValue: 156,
        ),
        AnalyticInfoCard(
          info: "Categories",
          infoImage: 'assets/images/category.png',
          infoColor: myConstants.primaryColor,
          infoValue: 12,
        ),
      ],
    );
  }
}
