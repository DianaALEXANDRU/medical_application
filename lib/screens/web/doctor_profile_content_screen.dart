import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';

import 'components/custom_app_bar.dart';

class DoctorProfileContentScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileContentScreen({Key? key, required this.doctor})
      : super(key: key);

  @override
  State<DoctorProfileContentScreen> createState() =>
      _DoctorProfileContentScreenState();
}

class _DoctorProfileContentScreenState
    extends State<DoctorProfileContentScreen> {
  @override
  Widget build(BuildContext context) {
    print("###################### Doctor: ${widget.doctor.lastName}");
    double width = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Dr. ${widget.doctor.firstName} ${widget.doctor.lastName}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                DefaultTabController(
                    length: 3, // length of tabs
                    initialIndex: 0,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: TabBar(
                              labelColor: myConstants.primaryColor,
                              unselectedLabelColor: Colors.black,
                              tabs: const [
                                Tab(
                                  text: 'Doctor details',
                                ),
                                Tab(text: 'Reviews'),
                                Tab(text: 'Program'),
                              ],
                            ),
                          ),
                          Container(
                              height: 400, //height of TabBarView
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey, width: 0.5))),
                              child: TabBarView(children: <Widget>[
                                SingleChildScrollView(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24.0, left: 24),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Profile picture',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  //fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  'Edit',
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 300,
                                          ),
                                          const Text(
                                            'Personal info',
                                            style: TextStyle(
                                              fontSize: 22,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 24.0),
                                          /* Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  'Name ',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Color(0xff252B5C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                          const SizedBox(height: 8.0),
                                          Container(
                                            height: 50.0,
                                            width: width * 0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Colors.white,
                                            ),
                                            child: TextField(
                                              // controller: exeperienceController,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  top: 16.0,
                                                ),
                                                hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff252B5C)
                                                      .withOpacity(0.5),
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Doctor details',
                                            style: TextStyle(
                                              fontSize: 22,
                                              //fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 2',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Text('Display Tab 3',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ]))
                        ])),
              ],
            ),
          ),
        );
      },
    );
  }
}
