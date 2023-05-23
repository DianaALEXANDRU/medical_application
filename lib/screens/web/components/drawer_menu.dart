import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/constants.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset('assets/images/logo.png'),
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.dashboard_customize,
              color: myConstants.primaryColor,
            ),
            title: const Text('Dashboard'),
            onTap: () {
              GoRouter.of(context).go("/");
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0 * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.category,
              color: myConstants.primaryColor,
            ),
            title: const Text('Category'),
            onTap: () {
              GoRouter.of(context).go("/category");
            },
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.medical_services_rounded,
              color: myConstants.primaryColor,
            ),
            title: const Text('Doctors'),
            onTap: () {
              GoRouter.of(context).go("/doctors");
            },
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.schedule,
              color: myConstants.primaryColor,
            ),
            title: const Text('Programs'),
            onTap: () {},
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.calendar_month,
              color: myConstants.primaryColor,
            ),
            title: const Text('Appointments'),
            onTap: () {
              GoRouter.of(context).go("/appointments");
            },
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.reviews,
              color: myConstants.primaryColor,
            ),
            title: const Text('Reviews'),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0 * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.supervised_user_circle_outlined,
              color: myConstants.primaryColor,
            ),
            title: const Text('Users'),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0 * 2),
            child: Divider(
              color: Colors.grey,
              thickness: 0.2,
            ),
          ),
          ListTile(
            horizontalTitleGap: 0.8,
            leading: Icon(
              Icons.exit_to_app,
              color: myConstants.primaryColor,
            ),
            title: const Text('Exit'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
