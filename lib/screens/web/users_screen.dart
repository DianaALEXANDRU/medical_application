import 'package:flutter/material.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';
import 'package:medical_application/screens/web/users_content_screen.dart';

import 'components/drawer_menu.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
              child: UsersContentScreen(),
            )
          ],
        ),
      ),
    );
  }
}
