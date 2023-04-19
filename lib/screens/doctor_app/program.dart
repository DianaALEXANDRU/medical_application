import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/utill/helpers.dart';

class DoctorProgramScreen extends StatefulWidget {
  const DoctorProgramScreen({Key? key}) : super(key: key);

  @override
  State<DoctorProgramScreen> createState() => _DoctorProgramScreenState();
}

class _DoctorProgramScreenState extends State<DoctorProgramScreen> {
  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        getIt<MedicalBloc>()
            .add(FetchProgramDays(doctorId: authState.user!.id));
        return BlocBuilder<MedicalBloc, MedicalState>(
          bloc: getIt<MedicalBloc>(),
          builder: (context, medicalState) {
            return Scaffold(
              backgroundColor: Colors.white,
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            content: Text(
                                "Ask the administrator details about program or if it needs any changes."),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
                title: const Text(
                  'Program',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              body: ListView.builder(
                itemCount: medicalState.programDays.length,
                itemBuilder: (BuildContext context, int index) {
                  final programDay = medicalState.programDays[index];
                  final appointments = medicalState.program[programDay] ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Text(
                          getDayOfWeek(medicalState.programDays[index]),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: medicalState
                            .program[medicalState.programDays[index]]!.length,
                        itemBuilder: (BuildContext context, int subIndex) {
                          final appointment = appointments[subIndex];
                          return Column(
                            children: [
                              if (subIndex - 1 > 1 &&
                                  appointments[subIndex - 1].endHour !=
                                      appointment.startHour)
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 24.0,
                                          right: 16.0,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: const Divider(
                                          color: Colors.black,
                                          height: 24,
                                          thickness: 1,
                                        ),
                                      ),
                                    ),
                                    const Text('Free Hours'),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          left: 16.0,
                                          right: 24.0,
                                          top: 16,
                                          bottom: 16,
                                        ),
                                        child: const Divider(
                                          color: Colors.black,
                                          height: 24,
                                          thickness: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      '${appointment.startHour} - ${appointment.endHour}',
                                    ),
                                    leading: const Icon(Icons.access_time),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
