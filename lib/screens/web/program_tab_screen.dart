import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/screens/web/time_piker.dart';

import '../../bloc/medical_bloc.dart';
import '../../main.dart';
import '../../models/doctor.dart';
import '../../models/programDto.dart';

class ProgramTabScreen extends StatefulWidget {

  final Doctor doctor;
  const ProgramTabScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<ProgramTabScreen> createState() => _ProgramTabScreenState();
}

class _ProgramTabScreenState extends State<ProgramTabScreen> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  List<Program> program = [];

  String? dropdownValueDay;
  String? dropdownValueSort='All';
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  var errorMessageProgram = '';

  void resetErrorMessages() {
    setState(() {
      errorMessageProgram = '';
    });
  }

  var addMode = false;

  bool isValidProgram(List<Program> allProgram, Program currentProgram) {
    bool isValid = true;

    if (currentProgram.startHour.compareTo(currentProgram.endHour) == 1) {
      setState(() {
        errorMessageProgram =
            'This can`t be added! The hours are not chosen correctly! ';
      });
      isValid = false;
    }
    for (var pr in allProgram) {
      if (pr.day == currentProgram.day &&
          pr.endHour == currentProgram.endHour &&
          pr.startHour == currentProgram.startHour) {
        setState(() {
          errorMessageProgram = 'This already exists!';
        });
        isValid = false;
      } else {
        if (currentProgram.startHour.compareTo(pr.startHour) == 1 &&
            currentProgram.startHour.compareTo(pr.endHour) == -1 &&
            currentProgram.day == pr.day) {

          setState(() {
            errorMessageProgram =
                'This can`t be added! It interferes with another program! ';
          });
          isValid = false;
        } else {
          if (currentProgram.endHour.compareTo(pr.startHour) == 1 &&
              currentProgram.endHour.compareTo(pr.endHour) == -1 &&
              currentProgram.day == pr.day) {

            setState(() {
              errorMessageProgram =
                  'This can`t be added! It interferes with another program! ';
            });
            isValid = false;
          }
        }
      }
    }

    return isValid;
  }

  List<Program> _runDayFilter(List<Program> allPrograms) {
    List<Program> results = [];
    if (dropdownValueSort == null || dropdownValueSort == 'All') {
      results = allPrograms;
    } else {

      for(var p in allPrograms){

        if(p.day== dropdownValueSort){
          results.add(p);

        }
      }
    }
    return results;
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        program=medicalState.programList;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: SingleChildScrollView(
                      child: PaginatedDataTable(
                        header: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Program '),
                            Container(
                              height: 50.0,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Colors.white,
                              ),
                              child: DropdownButton<String>(
                                value: dropdownValueSort,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValueSort= newValue;

                                  });
                                  _runDayFilter(program);
                                },
                                iconEnabledColor: Colors.blue,
                                isExpanded: true,
                                hint: Text(
                                  ' Choose a day',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff252B5C).withOpacity(0.5),
                                    fontSize: 16.0,
                                  ),
                                ),
                                items: <String>[
                                  'All',
                                  'Monday',
                                  'Tuesday',
                                  'Wednesday',
                                  'Thursday',
                                  'Friday',
                                  'Saturday',
                                  'Sunday'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  addMode = true;
                                });
                              },

                              child: const Text(
                                'Add ',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ],
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Day',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Start hour',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'End hour',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Delete',
                            ),
                          ),
                        ],
                        source: _ProgramSource(
                          program: _runDayFilter(program),
                          onPressed: (Program p) {
                            getIt<MedicalBloc>().add(
                               DeleteProgram(doctorId: widget.doctor.id, day: p.day, start: p.startHour, end: p.endHour),
                            );
                          },
                        ),
                        rowsPerPage: _rowsPerPage,
                        onRowsPerPageChanged: (int? value) {
                          setState(
                            () {
                              _rowsPerPage = value ??
                                  PaginatedDataTable.defaultRowsPerPage;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 48,
            ),
            if (addMode == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit_calendar_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          ' Day of week',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff252B5C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 50.0,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValueDay,
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValueDay = newValue;
                        });
                      },
                      iconEnabledColor: Colors.blue,
                      isExpanded: true,
                      hint: Text(
                        ' Choose a day',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff252B5C).withOpacity(0.5),
                          fontSize: 16.0,
                        ),
                      ),
                      items: <String>[
                        'Monday',
                        'Tuesday',
                        'Wednesday',
                        'Thursday',
                        'Friday',
                        'Saturday',
                        'Sunday'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.access_time_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          ' Start time',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff252B5C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TimePicker24H(
                    title: "Pick a start time: ",
                    initialTime: _selectedStartTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedStartTime = time;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.access_time_outlined,
                          color: Colors.blue,
                        ),
                        Text(
                          ' End time',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xff252B5C),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TimePicker24H(
                    title: "Pick an end time: ",
                    initialTime: _selectedEndTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedEndTime = time;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (dropdownValueDay != null &&
                              _selectedStartTime != null &&
                              _selectedEndTime != null) {
                            var start = DateFormat('HH:mm')
                                .format(_selectedStartTime!)
                                .toString();
                            var end = DateFormat('HH:mm')
                                .format(_selectedEndTime!)
                                .toString();
                            Program p = Program(
                                day: dropdownValueDay!,
                                startHour: start,
                                endHour: end);

                            //  bool programExists = program.contains(p);

                            if (isValidProgram(medicalState.programList, p) == true) {
                              getIt<MedicalBloc>().add(
                                 AddOneProgram(doctorId: widget.doctor.id, program: p),
                              );
                              resetErrorMessages();
                            }
                          } else {
                            setState(() {
                              errorMessageProgram =
                                  'You must complete all fields!';
                            });
                          }
                        },
                        child: const Text('Add program'),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            addMode = false;
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                  if (errorMessageProgram != '')
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          errorMessageProgram,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30.0),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ProgramSource extends DataTableSource {
  final List<Program> program;

  final void Function(Program p) onPressed;

  _ProgramSource({
    required this.program,
    required this.onPressed,
  });

  @override
  DataRow getRow(int index) {
    final data = program[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            data.day,
          ),
        ),
        DataCell(
          Text(
            data.startHour,
          ),
        ),
        DataCell(
          Text(
            data.endHour,
          ),
        ),
        DataCell(
          IconButton(
            color: Colors.red,
            onPressed: () {
              onPressed.call(program[index]);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => program.length;

  @override
  int get selectedRowCount => 0;
}
