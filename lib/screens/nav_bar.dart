import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/doctors_screen.dart';
import 'package:medical_application/screens/my_appointment_screen.dart';
import 'package:medical_application/screens/profile_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Hello,',
              style: TextStyle(fontSize: 16),
            ),
            accountEmail: const Text(
              'Diana Alexandru!',
              style: TextStyle(fontSize: 15),
            ),
            decoration: BoxDecoration(
              gradient: myConstants.linearGradientBlue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DoctorScreen(category: ''),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_list_rounded),
            title: const Text('Doctors'),
            onTap: () {
              context.go("/patientHome/doctors/all");
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('My appointments'),
            onTap: () {
              context.go("/patientHome/myAppointments");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              context.go("/patientHome/myProfile");
            },
          ),
          const Divider(),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              GoRouter.of(context).go("/login");
            },
            child: const ListTile(
              title: Text('Exit'),
              leading: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }
}
