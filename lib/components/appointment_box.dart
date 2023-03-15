import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/constants.dart';

class appointment_box extends StatelessWidget {
  final DateTime dateTime;
  final Appointment appointment;
  final Size size;

  const appointment_box({
    Key? key,
    required this.dateTime,
    required this.appointment,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    DateFormat dateFormat = DateFormat('dd MMMM yyyy        HH:mm');
    return Container(
      height: size.height * 0.16,
      width: size.width * 0.8,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: myConstants.primaryColor.withOpacity(.4),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(
                  size.height * 0.015,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date:                               Time:',
                      style: TextStyle(
                        color: Color(0xffababab),
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      dateFormat.format(appointment.date),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doctor:                        ',
                      style: TextStyle(
                        color: Color(0xffababab),
                        fontSize: 17,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      appointment.doctor.name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                  ),
                  child: const Text(
                    'Cancel',
                  ),
                )
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
