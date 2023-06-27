import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/web/add_category_widget.dart';
import 'package:medical_application/utill/helpers.dart';

import '../../bloc/medical_bloc.dart';
import '../../main.dart';
import '../../models/category.dart';
import 'edit_category_widget.dart';

class CategoryContentScreen extends StatefulWidget {
  const CategoryContentScreen({Key? key}) : super(key: key);

  @override
  State<CategoryContentScreen> createState() => _CategoryContentScreenState();
}

class _CategoryContentScreenState extends State<CategoryContentScreen> {
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  var addMode = false;
  var editMode = false;
  late Category categoryToEdit;

  String _filter = '';

  List<Category> _runFilter(List<Category> allCategories) {
    List<Category> results = [];
    if (_filter.isEmpty) {
      results = allCategories;
    } else {
      results = allCategories
          .where(
              (cat) => (cat.name).toLowerCase().contains(_filter.toLowerCase()))
          .toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Category> foundCategories = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        foundCategories = _runFilter(medicalState.categories);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: width * 0.35,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                _filter = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Search for category",
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
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: PaginatedDataTable(
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Categories'),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      editMode = false;
                                      addMode = true;
                                    });
                                  },
                                  child: const Text(
                                    'Add a new category',
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
                                label: Text('Image'),
                              ),
                              DataColumn(
                                label: Text('Name'),
                              ),
                              DataColumn(
                                label: Text('Edit'),
                              ),
                              DataColumn(
                                label: Text('Delete'),
                              ),
                            ],
                            source: _DataSource(
                                categories: foundCategories,
                                onPressedEditMode: (category) {
                                  setState(() {
                                    addMode = false;
                                    editMode = true;
                                    categoryToEdit = category;
                                  });
                                },
                                onPressedDelete: (category) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Category'),
                                        content: existingDoctorsByCategory(
                                                  medicalState.doctors,
                                                  category.name,
                                                ) ==
                                                0
                                            ? const Text(
                                                'Are you sure you want to delete this category?',
                                              )
                                            : Text(
                                                'You cant delete this category. ${existingDoctorsByCategory(
                                                  medicalState.doctors,
                                                  category.name,
                                                )} doctors exist in this Category',
                                              ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: existingDoctorsByCategory(
                                                      medicalState.doctors,
                                                      category.name,
                                                    ) ==
                                                    0
                                                ? const Text('No')
                                                : const Text('Cancel'),
                                          ),
                                          if (existingDoctorsByCategory(
                                                medicalState.doctors,
                                                category.name,
                                              ) ==
                                              0)
                                            TextButton(
                                              onPressed: () {
                                                getIt<MedicalBloc>().add(
                                                  DeleteCategory(
                                                      category: category),
                                                );

                                                getIt<MedicalBloc>().add(
                                                  const FetchCategories(),
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Yes'),
                                            ),
                                        ],
                                        elevation: 4.0,
                                      );
                                    },
                                  );
                                }),
                            rowsPerPage: _rowsPerPage,
                            onRowsPerPageChanged: (int? value) {
                              setState(() {
                                _rowsPerPage =
                                    value ?? PaginatedDataTable.defaultRowsPerPage;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 56,
                    ),
                    if (addMode == true)
                      AddCategoryWidget(
                        onPressed: () {
                          setState(() {
                            addMode = false;
                          });
                        },
                      ),
                    if (editMode == true)
                      EditCategoryWidget(
                          onPressedCancel: () {
                            setState(() {
                              editMode = false;
                            });
                          },
                          category: categoryToEdit),
                  ],
                ),
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
  final void Function(Category category) onPressedEditMode;
  final void Function(Category category) onPressedDelete;
  final List<Category> categories;

  _DataSource({
    required this.categories,
    required this.onPressedEditMode,
    required this.onPressedDelete,
  });

  @override
  DataRow getRow(int index) {
    Constants myConstants = Constants();
    final data = categories[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text('${index + 1}.'),
        ),
        DataCell(Container(
          decoration: BoxDecoration(
            color: myConstants.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data.url,
              //  fit: BoxFit.cover,
              width: 45,
              height: 45,
            ),
          ),
        )),
        DataCell(
          Text(data.name),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              onPressedEditMode.call(categories[index]);
            },
            icon: const Icon(Icons.edit, color: Colors.green),
          ),
        ),
        DataCell(
          IconButton(
            onPressed: () {
              onPressedDelete.call(categories[index]);
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
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
