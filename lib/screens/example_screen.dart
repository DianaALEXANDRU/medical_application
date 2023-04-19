import 'package:flutter/material.dart';
import '../models/constants.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: myConstants.primaryColor,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text(
          'Appointment Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: const [
            // AppointmentBoxDoctor(size: size),
          ],
        ),
      ),
    );
  }
}
