import 'package:flutter/material.dart';

import 'package:medical_application/screens/web/responsive_widget.dart';

import 'appointments_content_screen.dart';
import 'components/drawer_menu.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
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
              child: AppointmentsContentScreen(),
            )
          ],
        ),
      ),
    );
  }
}
