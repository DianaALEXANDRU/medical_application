import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

import '../bloc/medical_bloc.dart';
import '../utill/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool showLoginPage = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final passConfirmController = TextEditingController();

  var errorMessageForEmail = '';
  var errorMessageForLastName = '';
  var errorMessageForFirstName = '';
  var errorMessageForPhoneNo = '';
  var errorMessageForPass = '';
  var errorMessageForConfirm = '';
  var errorMessageField = '';
  var errorMessage = '';

  bool isValid() {
    bool isValid = true;

    if (isEmail(emailController.text.trim()) == false) {
      setState(() {
        errorMessageForEmail =
            'The text entered in the email field is not an email!';
      });

      isValid = false;
    }

    if (firstNameController.text.trim().length < 2 ||
        firstNameController.text.trim().length > 30) {
      setState(() {
        errorMessageForFirstName =
            'First Name must be between 2 and 30 characters!';
      });

      isValid = false;
    }

    if (lastNameController.text.trim().length < 2 ||
        lastNameController.text.trim().length > 30) {
      setState(() {
        errorMessageForLastName =
            'Last Name must be between 2 and 30 characters!';
      });

      isValid = false;
    }

    if (phoneNoController.text.trim().length < 8 ||
        phoneNoController.text.trim().length > 30) {
      setState(() {
        errorMessageForPhoneNo =
            'Phone No must be between 8 and 30 characters!';
      });

      isValid = false;
    }

    if (validatePassword(passController.text.trim()) == false) {
      setState(() {
        errorMessageForPass =
            'Password must be have at least 8 characters, 1 special character, 1 digit, uppercase and lowercase!';
      });

      isValid = false;
    }

    if (passController.text.trim() != passConfirmController.text.trim()) {
      setState(() {
        errorMessageForConfirm = 'Password confirmation is not valid!';
      });
      isValid = false;
    }

    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneNoController.text.trim().isEmpty ||
        passController.text.trim().isEmpty ||
        passConfirmController.text.trim().isEmpty) {
      setState(() {
        errorMessageField = 'All fields must be completed!';
      });

      isValid = false;
    }

    return isValid;
  }

  Future register() async {

      getIt<AuthBloc>().add(
        Register(
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNo: phoneNoController.text.trim(),
          email: emailController.text.trim(),
          password: passController.text.trim(),
        ),
      );

  }

  void resetFields() {
    setState(() {
      errorMessageForEmail = '';
      errorMessageForLastName = '';
      errorMessageForFirstName = '';
      errorMessageForPhoneNo = '';
      errorMessageForPass = '';
      errorMessageForConfirm = '';
      errorMessageField = '';
      errorMessage = '';
    });
  }

  bool passwordConfirmed() {
    if (passController.text.trim() == passConfirmController.text.trim()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    passController.dispose();
    passConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {
            return (oldState.errorMessage != newState.errorMessage);
          },
          listener: (context, state) async {
            setState(() {
              errorMessage = state.errorMessage!;
            });
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          bloc: getIt<AuthBloc>(),
          listenWhen: (oldState, newState) {
            return (oldState.user != newState.user && newState.errorMessage==null);
          },
          listener: (context, state) async {
            final role = getIt<AuthBloc>().state.user?.role;

            if (role == 'user') {
              getIt<MedicalBloc>().add(
                FetchAppointmentsForUser(
                    userId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                const FetchReviews(),
              );
              getIt<MedicalBloc>().add(
                const FetchAvailableDoctors(),
              );


              GoRouter.of(context).go("/patientHome");
              return;
            }
            if (role == 'doctor') {
              getIt<MedicalBloc>().add(
                FetchAppointmentsForDoctor(
                    userId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                const FetchUsers(),
              );
              getIt<MedicalBloc>().add(
                FetchReviewsByDoctorId(
                    doctorId: getIt<AuthBloc>().state.user!.id),
              );
              getIt<MedicalBloc>().add(
                  FetchProgram(doctorId: getIt<AuthBloc>().state.user!.id));

              GoRouter.of(context).go("/doctorHome");
              return;
            }
            GoRouter.of(context).go("/login");
          },
        ),

      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/main_top1.png',
                  width: size.width,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/images/main_bottom1.png',
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 24.0,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        'assets/images/log.png',
                        width: size.width * 0.4,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: size.width * 0.1,
                    top: size.height * 0.16,
                  ),
                  child: const Text(
                    'Welcome, Register!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: size.height * 0.22,
                    right: size.width * 0.1,
                    left: size.width * 0.1,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'First Name',
                          prefixIcon: Icon(
                            Icons.abc,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      if (errorMessageForFirstName != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForFirstName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForFirstName == '')
                        const SizedBox(
                          height: 24,
                        ),
                      TextField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Last Name',
                          prefixIcon: Icon(
                            Icons.abc,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      if (errorMessageForLastName != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForLastName,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForLastName == '')
                        const SizedBox(
                          height: 24,
                        ),
                      TextField(
                        controller: phoneNoController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Phone No.',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      if (errorMessageForPhoneNo != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForPhoneNo,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForPhoneNo == '')
                        const SizedBox(
                          height: 24,
                        ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      if (errorMessageForEmail != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForEmail,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForEmail == '')
                        const SizedBox(
                          height: 24,
                        ),
                      TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessageForPass != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForPass,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForPass == '')
                        const SizedBox(
                          height: 24,
                        ),
                      TextField(
                        controller: passConfirmController,
                        obscureText: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: myConstants.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 0.0,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessageForConfirm != '')
                        Column(
                          children: [
                            Text(
                              errorMessageForConfirm,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      if (errorMessageForConfirm == '')
                        const SizedBox(
                          height: 24,
                        ),
                      if (errorMessageField != '')
                        Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              errorMessageField,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 48.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isValid()) {
                              register();
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: myConstants.linearGradientBlue,
                            ),
                            child: Container(
                              width: size.width * 0.9,
                              alignment: Alignment.center,
                              child: const Text(
                                'REGISTER',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage != '')
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                          ),
                          InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/login");
                            },
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                color: myConstants.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
