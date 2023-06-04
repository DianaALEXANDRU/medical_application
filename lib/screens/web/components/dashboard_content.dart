import 'package:flutter/material.dart';
import 'package:medical_application/screens/web/components/analytic_cards.dart';
import 'package:medical_application/screens/web/components/doctor_by_categoies_widget.dart';
import 'package:medical_application/screens/web/components/doctors_raitings_widget.dart';
import 'package:medical_application/screens/web/components/last_7days_app_widget.dart';
import 'package:medical_application/screens/web/components/todays_appointments_widget.dart';
import 'package:medical_application/screens/web/components/custom_app_bar.dart';

import 'app_by_category_widget.dart';
import 'last_3months_app_widget.dart';

class DashboardContnet extends StatelessWidget {
  const DashboardContnet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomAppbar(),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: const [
                Expanded(
                  flex: 5,
                  child: AnalyticCards(),
                ),
              ],
            ),
            Row(
              children: const [
                Expanded(
                  flex: 5,
                  child: TodaysCompletedAppointmentsWidget(),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(flex: 5, child: Last7DaysAppointmentsWidget()),
              ],
            ),
            Row(
              children: const [
                DoctorsByCategoriesWidget(),
                SizedBox(
                  width: 16,
                ),
                Expanded(flex: 5, child: AppByCategoryWidget()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(width: 400, child: DoctorRatingWidget()),
                SizedBox(
                  width: 16,
                ),
                Expanded(flex: 5, child: Last3MonthsAppWidget()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
