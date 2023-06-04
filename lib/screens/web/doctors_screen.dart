import 'package:flutter/material.dart';

import 'package:medical_application/screens/web/doctors_content_screen.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';

import 'components/drawer_menu.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 251, 254, 1),
      drawer: const DrawerMenu(),
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
              child: DoctorContentScreen(),
            )
          ],
        ),
      ),
    );
  }
}
