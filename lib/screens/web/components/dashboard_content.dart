import 'package:flutter/material.dart';
import 'package:medical_application/screens/web/components/analytic_cards.dart';
import 'package:medical_application/screens/web/components/custom_app_bar.dart';

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
            TextField(
              decoration: InputDecoration(
                  hintText: "Search for Statistics",
                  helperStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 15,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(0.5),
                  )),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: const [
                Expanded(
                  flex: 5,
                  child: AnalyticCards(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
