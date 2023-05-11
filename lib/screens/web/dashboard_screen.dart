import 'package:flutter/material.dart';
import 'package:medical_application/screens/web/components/dashboard_content.dart';

import 'package:medical_application/screens/web/responsive_widget.dart';

import '../../controllers/controller.dart';
import 'components/drawer_menu.dart';
import 'package:provider/provider.dart';

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
      key: context.read<Controller>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ResponsiveWidget.isLargeScreen(context))
              const Expanded(
                child: DrawerMenu(),
              ),
            const Expanded(
              flex: 5,
              child: DashboardContnet(),
            )
          ],
        ),
      ),
    );
  }
}