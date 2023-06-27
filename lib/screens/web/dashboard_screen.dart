import 'package:flutter/material.dart';
import 'package:medical_application/screens/web/components/dashboard_content.dart';

import 'package:medical_application/screens/web/responsive_widget.dart';

import 'components/drawer_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 251, 254, 1),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(
              child: DrawerMenu(),
            ),
            Expanded(
              flex: 5,
              child: DashboardContnet(),
            )
          ],
        ),
      ),
    );
  }
}
