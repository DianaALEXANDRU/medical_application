import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/components/category_box.dart';
import 'package:medical_application/components/doctor_box.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/screens/doctors_screen.dart';
import 'package:medical_application/screens/nav_bar.dart';
import 'package:medical_application/screens/profile_screen.dart';

import '../bloc/auth/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = '';

  @override
  void initState() {
    super.initState();
  }

  List<Category> _runFilter(List<Category> allCategories) {
    List<Category> results = [];
    if (_filter.isEmpty) {
      results = allCategories;
    } else {
      results = allCategories
          .where(
            (cat) => cat.name.toLowerCase().contains(
                  _filter.toLowerCase(),
                ),
          )
          .toList();
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    List<Category> foundCategories = [];
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        return BlocBuilder<MedicalBloc, MedicalState>(
          bloc: getIt<MedicalBloc>(),
          builder: (context, medicalState) {
            foundCategories = _runFilter(medicalState.categories);
            return Scaffold(
              drawer: const NavBar(),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: myConstants.primaryColor,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ],
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
                        if (authState.user != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${authState.user!.firstName},',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Welcome back!',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
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
                            hintText: 'eg: Cardiology',
                            suffixIcon: const Icon(Icons.search),
                            suffixIconColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: foundCategories.isNotEmpty
                              ? ListView.builder(
                                  itemCount: foundCategories.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) =>
                                      CategoryWidget(
                                    category: foundCategories[index],
                                  ),
                                )
                              : const Text(
                                  'No results found',
                                  style: TextStyle(fontSize: 24),
                                ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: size.width * 0.05,
                      top: size.width * 0.05,
                      right: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Doctors',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DoctorScreen(
                                      category: '',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                ' See all',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: medicalState.doctors.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          bottom: 10,
                        ),
                        child: DoctorWidget(
                          size: size,
                          doctor: medicalState.doctors[index],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
