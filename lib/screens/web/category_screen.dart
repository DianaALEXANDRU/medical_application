import 'package:flutter/material.dart';

import 'package:medical_application/screens/web/responsive_widget.dart';

import 'category_content_screen.dart';
import 'components/drawer_menu.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
              child: CategoryContentScreen(),
            )
          ],
        ),
      ),
    );
  }
}
