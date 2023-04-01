import 'package:flutter/material.dart';
import 'package:medical_application/components/profile_box.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/profile_screen.dart';

class ConfirmAppointmentScreen extends StatefulWidget {
  const ConfirmAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmAppointmentScreen> createState() =>
      _ConfirmAppointmentScreenState();
}

class _ConfirmAppointmentScreenState extends State<ConfirmAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: myConstants.contrastColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: myConstants.primaryColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
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
        body: Column(
          children: [
            const SizedBox(
              height: 28,
            ),
            SizedBox(
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Expanded(
                    child: Text(
                      'Please check the details and confirm the appointment:',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: size.width,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 56,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Category',
                          details: 'Cardiology',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Doctor',
                          details: 'John Doe',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Date',
                          details: '26 Februarie 2023',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Time',
                          details: '10:45',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: myConstants.primaryColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Container(
                    width: size.width * 0.9,
                    height: 50,
                    alignment: Alignment.center,
                    child: const Text(
                      'Confirm',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
