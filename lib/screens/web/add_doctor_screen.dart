import 'package:flutter/material.dart';

import 'package:medical_application/screens/web/responsive_widget.dart';

import 'add_doctor_content_screen.dart';
import 'components/drawer_menu.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
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
              child: AddDoctorContentScreen(),
            )
          ],
        ),
      ),
    );
  }
}
