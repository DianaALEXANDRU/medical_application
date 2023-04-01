import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';

class NavBarDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Oflutter.com'),
            accountEmail: const Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://img.freepik.com/free-photo/portrait-young-male-doctor-with-stethoscope_171337-5084.jpg?w=1380&t=st=1675766319~exp=1675766919~hmac=640e42204a92bf6354a9c42e079866552653d18b0c357a51c98dc783611f153d',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              gradient: myConstants.linearGradientBlue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.view_list_rounded),
            title: const Text('Program'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Appointments'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Doctor Details'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
          const Divider(),
          const ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
