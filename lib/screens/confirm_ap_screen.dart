import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/profile_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/utill/helpers.dart';


class ConfirmAppScreen extends StatefulWidget {
  final Appointment app;

  const ConfirmAppScreen({
    Key? key,
    required this.app,
  }) : super(key: key);

  @override
  State<ConfirmAppScreen> createState() =>
      _ConfirmAppScreenState();
}

class _ConfirmAppScreenState extends State<ConfirmAppScreen> {
  Doctor? doctor = const Doctor(
      id: '',
      firstName: '',
      lastName: '',
      phoneNo: '',
      role: '',
      email: '',
      description: '',
      experience: '',
      imageUrl: '',
      category: '',
      available: true);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        doctor=findDoctorById(medicalState.doctors, widget.app.doctorId);
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
                  context.pop("/confirmAppointment");
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
                              details: doctor!.category,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'Doctor',
                              details:
                                  '${doctor!.firstName} ${doctor!.lastName}',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'Date',
                              details:
                                  DateFormat("dd/MM/yyyy").format(widget.app.dateAndTime),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ProfileDetailsWidget(
                              size: size,
                              field: 'Time',
                              details: DateFormat("HH:mm").format(widget.app.dateAndTime),
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
                              patientId: widget.app.patientId,
                              doctorId: widget.app.doctorId,
                              date: widget.app.dateAndTime,
                              hour: DateFormat("HH:mm").format(widget.app.dateAndTime)),
                        );
                        getIt<MedicalBloc>().add(
                          FetchAppointmentsForUser(
                            userId: widget.app.patientId,
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
                                    context.go("/patientHome");
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
      },
    );
  }
}
