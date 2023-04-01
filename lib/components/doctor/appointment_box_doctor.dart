import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';

class AppointmentBoxDoctor extends StatelessWidget {
  final Size size;

  const AppointmentBoxDoctor({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return Card(
      elevation: 6,
      child: SizedBox(
        height: 230,
        width: 328,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Date:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '20 Decembrie 2023',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 216, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Time:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                '13:10',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Patient:',
                                style: TextStyle(
                                  color: Color(0xffababab),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'Alexandru Costel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 24, top: 24),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text(
                              'Add Document',
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 216, top: 24),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                            ),
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
