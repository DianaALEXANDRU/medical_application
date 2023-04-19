import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

class ProfileForDoctorScreen extends StatefulWidget {
  const ProfileForDoctorScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileForDoctorScreen> createState() => _ProfileForDoctorScreenState();
}

class _ProfileForDoctorScreenState extends State<ProfileForDoctorScreen> {
  bool edit = false;
  bool editFirstNameVar = false;
  String firstName = '';
  bool editLastNameVar = false;
  String lastName = '';
  bool editPhoneNoVar = false;
  String phoneNo = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    void editFirstName(String fName) {
      setState(() {
        if (editFirstNameVar == false) {
          editFirstNameVar = true;
          firstName = fName;
        }
      });
    }

    void resetFirstNameState() {
      setState(() {
        if (editFirstNameVar == true) {
          editFirstNameVar = false;
        }
      });
    }

    void editLastName(String lName) {
      setState(() {
        if (editLastNameVar == false) {
          editLastNameVar = true;
          lastName = lName;
        }
      });
    }

    void resetLastNameState() {
      setState(() {
        if (editLastNameVar == true) {
          editLastNameVar = false;
        }
      });
    }

    void editPhoneNo(String pNo) {
      setState(() {
        if (editPhoneNoVar == false) {
          editPhoneNoVar = true;
          phoneNo = pNo;
        }
      });
    }

    void resetPhoneNoState() {
      setState(() {
        if (editPhoneNoVar == true) {
          editPhoneNoVar = false;
        }
      });
    }

    void editMode() {
      setState(() {
        if (edit == false) {
          edit = true;
        } else {
          edit = false;
        }
      });
    }

    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();
    var phoneNoController = TextEditingController();
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        if (editFirstNameVar == false) {
          firstNameController =
              TextEditingController(text: authState.user!.firstName);
        } else {
          firstNameController = TextEditingController(text: firstName);
        }

        if (editLastNameVar == false) {
          lastNameController =
              TextEditingController(text: authState.user!.lastName);
        } else {
          lastNameController = TextEditingController(text: lastName);
        }

        if (editPhoneNoVar == false) {
          phoneNoController =
              TextEditingController(text: authState.user!.phoneNo);
        } else {
          phoneNoController = TextEditingController(text: phoneNo);
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: myConstants.contrastColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  editMode();
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    SizedBox(
                      width: size.width,
                      height: size.height * 0.25,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: myConstants.linearGradientBlue,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 110,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                              width: size.width / 3,
                              height: size.height / 6,
                              imageUrl: authState.doctor!.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (edit == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: size.width * 0.9,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: const Text(
                                    'Edit the details that you want and then press "save details".',
                                    style: TextStyle(
                                      color: Color(0xff363636),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'First Name',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled: edit,
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter a search term',
                                  ),
                                  onEditingComplete: () {
                                    editFirstName(firstNameController.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Last Name',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled: edit,
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter the details',
                                  ),
                                  onEditingComplete: () {
                                    editLastName(lastNameController.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phone Number',
                                style: TextStyle(
                                  color: Color(0xff363636),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                height: 60,
                                width: size.width * 0.9,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                // child:
                                child: TextField(
                                  enabled: edit,
                                  controller: phoneNoController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter a search term',
                                  ),
                                  onEditingComplete: () {
                                    editPhoneNo(phoneNoController.text);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (edit == true)
                            InkWell(
                              onTap: () {
                                getIt<MedicalBloc>().add(
                                  EditUserDetails(
                                    userId: authState.user!.id,
                                    firstName: firstName,
                                    lastName: lastName,
                                    phoneNo: phoneNo,
                                  ),
                                );
                                getIt<AuthBloc>().add(const FetchUser());
                                editMode();
                                resetFirstNameState();
                                resetLastNameState();
                                resetPhoneNoState();
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  color: myConstants.primaryColor,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Container(
                                  width: size.width * 0.9,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Save details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
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
