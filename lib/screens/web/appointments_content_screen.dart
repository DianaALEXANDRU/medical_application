import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/utill/helpers.dart';

import 'components/custom_app_bar.dart';

class AppointmentsContentScreen extends StatefulWidget {
  const AppointmentsContentScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsContentScreen> createState() =>
      _AppointmentsContentScreenState();
}

class _AppointmentsContentScreenState extends State<AppointmentsContentScreen> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CustomAppbar(),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Search for a date",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Appointments'),
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
                                appointments: medicalState.appointments,
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
          email == null ? const Text('') : Text(email!),
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
