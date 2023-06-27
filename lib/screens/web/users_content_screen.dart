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

  List<UserClass> _runFilter(List<UserClass> allUsers) {
    List<UserClass> results = [];
    if (_filter.isEmpty) {
      results = allUsers;
    } else {
      results = allUsers
          .where((user) =>
              ('${user.firstName} ${user.lastName} ${user.phoneNo} ${user.email}')
                  .toLowerCase()
                  .contains(_filter.toLowerCase()))
          .toList();
    }

    return results;
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  List<UserClass> filterdUsers = [];

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
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Search for Users",
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
                              header: const Text('Users details'),
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
                                    label: Text('Email'),
                                    ),
                              ],
                              source: _DataSource(
                                users: foundUsers,
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
  final List<UserClass> users;

  _DataSource({required this.users});

  @override
  DataRow getRow(int index) {
    final data = users[index];
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
          Text(data.email),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
