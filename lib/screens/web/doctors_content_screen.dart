import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/utill/helpers.dart';

import 'components/custom_app_bar.dart';

class DoctorContentScreen extends StatefulWidget {
  const DoctorContentScreen({Key? key}) : super(key: key);

  @override
  State<DoctorContentScreen> createState() => _DoctorContentScreenState();
}

class _DoctorContentScreenState extends State<DoctorContentScreen> {
  String _filter = '';

  List<Doctor> _runFilter(List<Doctor> allDoctors) {
    List<Doctor> results = [];
    if (_filter.isEmpty) {
      results = allDoctors;
    } else {
      results = allDoctors
          .where((doctor) => ('${doctor.firstName} ${doctor.lastName}')
              .toLowerCase()
              .contains(_filter.toLowerCase()))
          .toList();
    }

    return results;
  }

  List<Doctor> _runCategoryFilter(List<Doctor> allDoctors) {
    List<Doctor> results = [];
    if (dropdownValueCategory == null ||
        dropdownValueCategory == 'All categories') {
      results = allDoctors;
    } else {
      results = allDoctors
          .where((doctor) => (doctor.category)
              .toLowerCase()
              .contains(dropdownValueCategory!.toLowerCase()))
          .toList();
    }

    return results;
  }

  String? dropdownValueCategory;

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<String> categoryFilters = [];

  List<Doctor> filterdDoctors = [];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Doctor> foundDoctors = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        foundDoctors = _runFilter(medicalState.doctors);
        categoryFilters = makeCategoryFilters(medicalState.categories);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Search for Doctor",
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
                        // Data table widget in not scrollable so we have to wrap it in a scroll view when we have a large data set..
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: SingleChildScrollView(
                            child: PaginatedDataTable(
                              header: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text('Doctors details'),
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
                                            _runCategoryFilter(foundDoctors);
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
                                  TextButton(
                                    onPressed: () {
                                      context.go('/doctors/addDoctor');
                                    },
                                    child: const Text(
                                      'Add new doctor',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                              columns: const [
                                DataColumn(
                                    label: Text('No.'),
                               ),
                                DataColumn(
                                    label: Text('First Name'),
                                    ),
                                DataColumn(
                                    label: Text('Last Name'),
                                   ),
                                DataColumn(
                                    label: Text('Phone'),
                                ),
                                DataColumn(
                                    label: Text('Category'),
                                 ),
                                DataColumn(
                                    label: Text('Availability'),
                                   ),
                                DataColumn(
                                    label: Text('View more'),
                                    ),
                              ],
                              source: dropdownValueCategory != null
                                  ? _DataSource(
                                      doctors: _runCategoryFilter(foundDoctors),
                                      onPressedNavigate: (doctorView) {

                                        context.go(
                                            '/doctors/doctorDetails/${doctorView!.id}');
                                      })
                                  : _DataSource(
                                      doctors: foundDoctors,
                                      onPressedNavigate: (doctorView) {

                                        context.go(
                                            '/doctors/doctorDetails/${doctorView!.id}');
                                      }),
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
  final void Function(Doctor doctor) onPressedNavigate;

  final List<Doctor> doctors;

  _DataSource({required this.doctors, required this.onPressedNavigate});

  @override
  DataRow getRow(int index) {
    final data = doctors[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text('${index + 1}'),
        ),
        DataCell(
          Text(data.firstName),
        ),
        DataCell(
          Text(data.lastName),
        ),
        DataCell(
          Text(data.phoneNo),
        ),
        DataCell(
          Text(data.category),
        ),
        DataCell(
           data.available==true?  const Text('available'):const Text('not available') ,
        ),
        DataCell(
          IconButton(
            onPressed: () {
              onPressedNavigate.call(doctors[index]);
              getIt<MedicalBloc>().add(FetchProgramList(doctorId: data.id));
            },
            icon: const Icon(Icons.arrow_forward, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => doctors.length;

  @override
  int get selectedRowCount => 0;
}
