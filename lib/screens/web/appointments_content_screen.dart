import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/utill/helpers.dart';

import '../../models/doctor.dart';
import 'components/custom_app_bar.dart';

class AppointmentsContentScreen extends StatefulWidget {
  const AppointmentsContentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsContentScreen> createState() =>
      _AppointmentsContentScreenState();
}

class _AppointmentsContentScreenState extends State<AppointmentsContentScreen> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  String? dropdownValueTime = 'All';

  String _filter = '';

  List<Appointment> _runFilter(List<Appointment> allAppointment) {
    List<Appointment> results = [];
    if (_filter.isEmpty) {
      results = allAppointment;
    } else {
      results = allAppointment.where((app) {
        var doctor =
            findDoctorById(getIt<MedicalBloc>().state.doctors, app.doctorId);
        var firstName = doctor?.firstName ?? '';
        var lastName = doctor?.lastName ?? '';
        var name = firstName + lastName;
        var lowercaseName = name.toLowerCase();
        var lowercaseFilter = _filter.toLowerCase();
        return lowercaseName.contains(lowercaseFilter);
      }).toList();
    }

    return results;
  }

  List<Appointment> _runFilterUpcoming(List<Appointment> allAppointments) {
    List<Appointment> results = [];

    results = allAppointments
        .where((appointment) => appointment.dateAndTime.isAfter(DateTime.now()))
        .toList();

    return results;
  }

  List<Appointment> _runFilterPast(List<Appointment> allAppointments) {
    List<Appointment> results = [];

    results = allAppointments
        .where(
            (appointment) => appointment.dateAndTime.isBefore(DateTime.now()))
        .toList();

    return results;
  }

  List<Appointment> _runTimeFilter(List<Appointment> allAppointments) {
    List<Appointment> results = [];
    if (dropdownValueTime == null || dropdownValueTime == 'All') {
      results = allAppointments;
    } else {
      if (dropdownValueTime == 'Past') {
        results = _runFilterPast(allAppointments);
      } else {
        if (dropdownValueTime == 'Upcoming') {
          results = _runFilterUpcoming(allAppointments);
        }
      }
    }
    if (results != []) {
      results = _runCategoryFilter(results);
    }
    return results;
  }

  var dropDownItemsTime = [
    'All',
    'Upcoming',
    'Past',
  ];

  List<Appointment> _runCategoryFilter(List<Appointment> allAppointment) {
    List<Appointment> results = [];
    if (dropdownValueCategory == null ||
        dropdownValueCategory == 'All categories') {
      results = allAppointment;
    } else {
      results = allAppointment
          .where((app) =>
              (findDoctorById(getIt<MedicalBloc>().state.doctors, app.doctorId)!
                      .category)
                  .toLowerCase()
                  .contains(dropdownValueCategory!.toLowerCase()))
          .toList();
    }

    return results;
  }

  String? dropdownValueCategory = 'All categories';
  List<String> categoryFilters = [];

  List<Appointment> foundAppointments = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        foundAppointments = _runFilter(medicalState.appointments);
        categoryFilters = makeCategoryFilters(medicalState.categories);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CustomAppbar(),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Search by name ",
                      helperStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 15,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(0.5),
                      )),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              header: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Appointments'),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  Container(
                                    height: 50.0,
                                    width: width * 0.10,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<String>(
                                      value: dropdownValueTime,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValueTime = newValue;
                                        });
                                        _runTimeFilter(foundAppointments);
                                      },
                                      iconEnabledColor: Colors.blue,
                                      isExpanded: true,
                                      hint: Text(
                                        ' Choose a Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff252B5C)
                                              .withOpacity(0.5),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      items: dropDownItemsTime
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
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
                                    width: 24,
                                  ),
                                  Container(
                                    height: 50.0,
                                    width: width * 0.10,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: DropdownButton<String>(
                                      value: dropdownValueCategory,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dropdownValueCategory = newValue;
                                        });
                                        _runCategoryFilter(foundAppointments);
                                      },
                                      iconEnabledColor: Colors.blue,
                                      isExpanded: true,
                                      hint: Text(
                                        ' Choose a Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff252B5C)
                                              .withOpacity(0.5),
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      items: categoryFilters
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                              columns: const [
                                DataColumn(
                                  label: Text('No.'),
                                ),
                                DataColumn(
                                  label: Text('Doctor Name'),
                                ),
                                DataColumn(
                                  label: Text('Category'),
                                ),
                                DataColumn(
                                  label: Text('Date and time'),
                                ),
                                DataColumn(
                                  label: Text('Patient Email'),
                                ),
                                DataColumn(
                                  label: Text('Confirm'),
                                ),
                                DataColumn(
                                  label: Text('Delete'),
                                ),
                              ],
                              source: _DataSource(
                                appointments: _runTimeFilter(foundAppointments),
                                onPressed: (String appointmentId) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                          'Cancel Appointment',
                                        ),
                                        content: const Text(
                                          'Are you sure you want to cancel your appointment?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'No',
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              getIt<MedicalBloc>().add(
                                                DeleteAppointment(
                                                  appointmentId: appointmentId,
                                                ),
                                              );
                                              getIt<MedicalBloc>().add(
                                                const FetchAllAppointments(),
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Yes',
                                            ),
                                          ),
                                        ],
                                        elevation: 4.0,
                                      );
                                    },
                                  );
                                },
                              ),
                              rowsPerPage: _rowsPerPage,
                              onRowsPerPageChanged: (int? value) {
                                setState(() {
                                  _rowsPerPage = value ??
                                      PaginatedDataTable.defaultRowsPerPage;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DataSource extends DataTableSource {
  final List<Appointment> appointments;

  final void Function(String appointmentId) onPressed;

  _DataSource({
    required this.appointments,
    required this.onPressed,
  });

  @override
  DataRow getRow(int index) {
    final data = appointments[index];
    var doctor =
        findDoctorById(getIt<MedicalBloc>().state.doctors, data.doctorId);
    var email = findUserById(data.patientId)?.email;
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text('${index + 1}.'),
        ),
        DataCell(
          doctor?.firstName == null
              ? const Text("")
              : Text('${doctor!.firstName} ${doctor.lastName}'),
        ),
        DataCell(
          doctor?.category == null ? const Text("") : Text(doctor!.category),
        ),
        DataCell(
          Text(DateFormat('dd/MM/yyyy HH:mm').format(data.dateAndTime)),
        ),
        DataCell(
          email == null ? const Text('') : Text(email),
        ),
        DataCell(
          IconButton(
            disabledColor: Colors.grey,
            color: Colors.green,
            onPressed: data.confirmed == true
                ? null
                : () {
                    getIt<MedicalBloc>().add(ConfirmeAppointment(
                        appointmentId: appointments[index].id));
                    Future.delayed(const Duration(milliseconds: 100), () {
                      getIt<MedicalBloc>().add(
                        const FetchAllAppointments(),
                      );
                    });
                  },
            icon: const Icon(
              Icons.verified, //color: Colors.green
            ),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              onPressed.call(appointments[index].id);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => appointments.length;

  @override
  int get selectedRowCount => 0;
}
