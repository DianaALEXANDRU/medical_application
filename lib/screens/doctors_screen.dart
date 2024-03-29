import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/doctor_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/utill/helpers.dart';

class DoctorScreen extends StatefulWidget {
  final String category;

  const DoctorScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  String _filter = '';

  @override
  void initState() {
    super.initState();
  }

  List<Doctor> _runFilter(List<Doctor> allDoctors) {
    List<Doctor> results = [];
    if (widget.category != 'all') {
      allDoctors = allDoctors
          .where((doctor) =>
              doctor.available == true &&
              doctor.category
                  .toLowerCase()
                  .contains(widget.category.toLowerCase()))
          .toList();
    }
    if (_filter.isEmpty) {
      results = getAvailableDoctors(allDoctors);
    } else {
      results = allDoctors
          .where((doctor) =>
              doctor.available == true &&
              ('${doctor.firstName} ${doctor.lastName}')
                  .toLowerCase()
                  .contains(_filter.toLowerCase()))
          .toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    List<Doctor> foundDoctors = [];
    return BlocBuilder<MedicalBloc, MedicalState>(
      bloc: getIt<MedicalBloc>(),
      builder: (context, medicalState) {
        foundDoctors = _runFilter(medicalState.doctors);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: myConstants.primaryColor,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.go("/patientHome");
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Our Doctors',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: size.width * 0.05,
                  top: size.width * 0.05,
                  right: size.width * 0.05,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          _filter = value;
                        });
                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: myConstants.greyColor.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'eg: John Doe',
                        suffixIcon: const Icon(Icons.search),
                        suffixIconColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Expanded(
                child: foundDoctors.isNotEmpty
                    ? ListView.builder(
                        itemCount: foundDoctors.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            bottom: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              context.go(
                                  "${GoRouter.of(context).location}/doctorDetails/${foundDoctors[index].id}");
                            },
                            child: DoctorWidget(
                              size: size,
                              doctor: foundDoctors[index],
                            ),
                          ),
                        ),
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
