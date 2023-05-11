import 'package:flutter/material.dart';
import 'package:medical_application/controllers/controller.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';

import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Row(
      children: [
        if (!ResponsiveWidget.isLargeScreen(context))
          IconButton(
            onPressed: context.read<Controller>().controlMenu,
            icon: Icon(
              Icons.menu,
              color: myConstants.primaryColor,
            ),
          ),
      ],
    );
  }
}
