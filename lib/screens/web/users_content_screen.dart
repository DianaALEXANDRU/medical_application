import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/user.dart';

import 'components/custom_app_bar.dart';

class UsersContentScreen extends StatefulWidget {
  const UsersContentScreen({Key? key}) : super(key: key);

  @override
  State<UsersContentScreen> createState() => _UsersContentScreenState();
}

class _UsersContentScreenState extends State<UsersContentScreen> {
  String _filter = '';

  @override
  void initState() {
    super.initState();
  }

  List<UserClass> _runFilter(List<UserClass> allUsers) {
    List<UserClass> results = [];
    if (_filter.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers
          .where(
            (cat) => cat.email.toLowerCase().contains(
                  _filter.toLowerCase(),
                ),
          )
          .toList();
    }

    return results;
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  @override
  Widget build(BuildContext context) {
    List<UserClass> foundUsers = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        foundUsers = _runFilter(medicalState.users);
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
                      hintText: "Search for User, enter an email",
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
                                children: const [
                                  Text('Users'),
                                  // TextButton(
                                  //   onPressed: () {},
                                  //   child: const Text(
                                  //     'Add new doctor',
                                  //     style: TextStyle(fontSize: 16.0),
                                  //   ),
                                  // ),
                                ],
                              ),
                              columns: const [
                                DataColumn(
                                    label: Text('No.'),
                                    tooltip: 'represents if user is verified.'),
                                DataColumn(
                                    label: Text('First Name'),
                                    tooltip:
                                        'represents first name of the user'),
                                DataColumn(
                                    label: Text('Last Name'),
                                    tooltip:
                                        'represents last name of the user'),
                                DataColumn(
                                    label: Text('Phone No.'),
                                    tooltip:
                                        'represents phone number of the user'),
                                DataColumn(
                                    label: Text('Email'),
                                    tooltip:
                                        'represents phone number of the user'),
                                DataColumn(
                                    label: Text('Edit'),
                                    tooltip:
                                        'represents phone number of the user'),
                                DataColumn(
                                    label: Text('Delete'),
                                    tooltip:
                                        'represents phone number of the user'),
                              ],
                              source: _DataSource(foundUsers),
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
//  final List<Map<String, dynamic>> _dataList;
  final List<UserClass> doctors;

  _DataSource(this.doctors);

  @override
  DataRow getRow(int index) {
    final data = doctors[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text('${index + 1}.'),
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
          Text(data.email),
        ),
        DataCell(
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.green),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete, color: Colors.red),
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
