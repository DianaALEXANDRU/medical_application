import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/profile_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';

import 'home_screen.dart';

class ConfirmAppointmentScreen extends StatefulWidget {
  final String patientId;
  final Doctor doctor;
  final DateTime date;
  final String hour;

  const ConfirmAppointmentScreen({
    Key? key,
    required this.patientId,
    required this.doctor,
    required this.date,
    required this.hour,
  }) : super(key: key);

  @override
  State<ConfirmAppointmentScreen> createState() =>
      _ConfirmAppointmentScreenState();
}

class _ConfirmAppointmentScreenState extends State<ConfirmAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    print(
        "################################### ${GoRouter.of(context).location} ");
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
                          details: widget.doctor.category,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Doctor',
                          details:
                              '${widget.doctor.firstName} ${widget.doctor.lastName}',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Date',
                          details: DateFormat("dd/MM/yyyy").format(widget.date),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileDetailsWidget(
                          size: size,
                          field: 'Time',
                          details: widget.hour,
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
                child: InkWell(
                  onTap: () {
                    getIt<MedicalBloc>().add(
                      AddAppointment(
                          patientId: widget.patientId,
                          doctorId: widget.doctor.id,
                          date: widget.date,
                          hour: widget.hour),
                    );
                    getIt<MedicalBloc>().add(
                      FetchAppointmentsForUser(
                        userId: widget.patientId,
                      ),
                    );
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Appointment status'),
                          content: const Text(
                              'Your appointment is booked. See you soon!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          elevation: 4.0,
                        );
                      },
                    );
                  },
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
            ),
          ],
        ),
      ),
    );
  }
}
