import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/programDto.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/screens/web/time_piker.dart';

import 'components/custom_app_bar.dart';

class AddDoctorContentScreen extends StatefulWidget {
  const AddDoctorContentScreen({Key? key}) : super(key: key);

  @override
  State<AddDoctorContentScreen> createState() => _AddDoctorContentScreenState();
}

class _AddDoctorContentScreenState extends State<AddDoctorContentScreen> {
  int currentStep = 0;

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
    if (currentStep == 2) {
      addDoctor = true;
    }
  }

  bool addDoctor = false;

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlBuilders(context, details) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: currentStep != 2
                ? details.onStepContinue
                : () {
                    details.onStepContinue;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Add Doctor',
                          ),
                          content: const Text(
                            'Are you sure you want to make this user doctor?',
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
                                  MakeDoctor(
                                    userId: selectedUser.id,
                                    category: dropdownValueCategory!.name,
                                    experience:
                                        exeperienceController.text.trim(),
                                    description:
                                        descriptionController.text.trim(),
                                    program: program,
                                    selctFile: selctFile,
                                    selectedImageInBytes: selectedImageInBytes,
                                  ),
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
            child: currentStep == 2
                ? const Text(
                    'Add doctor',
                  )
                : const Text(
                    'Next',
                  ),
          ),
          const SizedBox(width: 10),
          OutlinedButton(
            onPressed: details.onStepCancel,
            child: const Text(
              'Back',
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _experienceController = TextEditingController();
  String _experience = '';

  String _filter = '';

  //image piker

  String defaultImageUrl =
      'https://firebasestorage.googleapis.com/v0/b/fluttermedicalapp-ab48a.appspot.com/o/CATEGORY%2Fdefault_category.png?alt=media&token=69d75b49-e6c5-4e83-96c1-1bf3003f9560';
  String selctFile = '';
  late XFile file;
  late Uint8List? selectedImageInBytes;
  List<Uint8List> pickedImagesInBytes = [];
  List<String> imageUrls = [];
  int imageCounts = 0;

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selctFile = fileResult.files.first.name;
      });

      selectedImageInBytes = fileResult.files.first.bytes;
    }
    print(selctFile);
  }

  @override
  void initState() {
    super.initState();
    _experienceController.addListener(_onExperienceChanged);
  }

  void _onExperienceChanged() {
    setState(() {
      _experience = _experienceController.text;
    });
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

  UserClass selectedUser = const UserClass(
      id: '', firstName: '', lastName: '', phoneNo: '', role: '', email: '');

  void setUser(UserClass user) {
    setState(() {
      selectedUser = user;
    });
  }

  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;

  List<Program> program = [];
  Category? dropdownValueCategory;
  String? dropdownValueDay;

  String description = '';

  final exeperienceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        var foundUsers = _runFilter(medicalState.users);

        return Scaffold(
          body: Stepper(
            elevation: 0,
            controlsBuilder: controlBuilders,
            type: StepperType.horizontal,
            physics: const ScrollPhysics(),
            onStepTapped: onStepTapped,
            onStepContinue: continueStep,
            onStepCancel: cancelStep,
            currentStep: currentStep,
            steps: [
              Step(
                title: const Text('Choose an user'),
                content: SingleChildScrollView(
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
                          ),
                        ),
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
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: SingleChildScrollView(
                                  child: PaginatedDataTable(
                                    header: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Users'),
                                      ],
                                    ),
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'No.',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'First Name',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Last Name',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Phone No.',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Email',
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Select',
                                        ),
                                      ),
                                    ],
                                    source: _DataSource(
                                      doctors: foundUsers,
                                      onPressed: (UserClass user) {
                                        setUser(user);
                                      },
                                      selectedUser: selectedUser,
                                    ),
                                    rowsPerPage: _rowsPerPage,
                                    onRowsPerPageChanged: (int? value) {
                                      setState(
                                        () {
                                          _rowsPerPage = value ??
                                              PaginatedDataTable
                                                  .defaultRowsPerPage;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text(
                  'Add doctor details',
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                              Text(
                                ' Experience',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff252B5C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: exeperienceController,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                top: 16.0,
                              ),
                              hintText: ' Enter your years of experience',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff252B5C).withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.control_point_duplicate,
                                color: Colors.blue,
                              ),
                              Text(
                                ' Category',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff252B5C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: DropdownButton<Category>(
                            value: dropdownValueCategory,
                            onChanged: (Category? newValue) {
                              setState(() {
                                dropdownValueCategory = newValue;
                              });
                            },
                            iconEnabledColor: Colors.blue,
                            isExpanded: true,
                            hint: Text(
                              ' Choose a Category',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff252B5C).withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                            items: medicalState.categories
                                .map<DropdownMenuItem<Category>>((
                              Category value,
                            ) {
                              return DropdownMenuItem<Category>(
                                value: value,
                                child: Text(
                                  value.name,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.short_text_sharp,
                                color: Colors.blue,
                              ),
                              Text(
                                ' Description',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff252B5C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          width: width * 0.35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: descriptionController,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: ' Enter a short description',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff252B5C).withOpacity(0.5),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.image,
                                color: Colors.blue,
                              ),
                              Text(
                                ' Profile Image',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color(0xff252B5C),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: selctFile.isEmpty
                              ? Image.network(
                                  defaultImageUrl,
                                  fit: BoxFit.cover,
                                )
                              : Image.memory(
                                  selectedImageInBytes!,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _selectFile(true);
                          },
                          child: const Text(
                            'Select Image',
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  ],
                ),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text(
                  'Add program',
                ),
                content: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

                              bool programExists = program.contains(p);

                              if (programExists == false) {
                                setState(() {
                                  program.add(p);
                                });
                              }
                            }
                          },
                          child: const Text('Add program'),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: SingleChildScrollView(
                              child: PaginatedDataTable(
                                header: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Program '),
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
                                  program: program,
                                  onPressed: (Program p) {
                                    setState(() {
                                      program.removeWhere((pr) =>
                                          pr.day == p.day &&
                                          pr.startHour == p.startHour &&
                                          pr.endHour == p.endHour);
                                    });
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
                  ],
                ),
                isActive: currentStep >= 0,
                state:
                    currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DataSource extends DataTableSource {
  final List<UserClass> doctors;

  final void Function(UserClass) onPressed;
  final UserClass selectedUser;

  _DataSource({
    required this.doctors,
    required this.onPressed,
    required this.selectedUser,
  });

  @override
  DataRow getRow(int index) {
    final data = doctors[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            '${index + 1}.',
          ),
        ),
        DataCell(
          Text(
            data.firstName,
          ),
        ),
        DataCell(
          Text(
            data.lastName,
          ),
        ),
        DataCell(
          Text(
            data.phoneNo,
          ),
        ),
        DataCell(
          Text(
            data.email,
          ),
        ),
        DataCell(
          IconButton(
            color: selectedUser.id != data.id ? Colors.grey : Colors.green,
            onPressed: () {
              onPressed.call(data);
            },
            icon: const Icon(Icons.check_circle),
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
