import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

import '../bloc/medical_bloc.dart';
import '../utill/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  Future logIn() async {
    getIt<AuthBloc>().add(
      LogIn(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  var errorMessage = '';
  var errorMessageForEmail = '';
  var errorMessageForPassword = '';

  void resetErrorMesssage() {
    setState(() {
      errorMessage = '';
      errorMessageForEmail = '';
      errorMessageForPassword = '';
    });
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
            return (oldState.loading &&
                !newState.loading &&
                newState.user != null);
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
                const FetchDoctors(),
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

            FirebaseAuth.instance.signOut();
            setState(() {
              errorMessage='Invalid account!';
            });

          },
        ),
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
                      height: 30.0,
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
                    top: size.height * 0.2,
                  ),
                  child: const Text(
                    'Welcome Back,\nLog In!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 33,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: size.height * 0.37,
                    right: size.width * 0.1,
                    left: size.width * 0.1,
                  ),
                  child: Column(
                    children: [
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
                            const SizedBox(
                              height: 8,
                            ),
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
                      const SizedBox(
                        height: 30,
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
                      if (errorMessageForPassword != '')
                        Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              errorMessageForPassword,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go("/resetPassword");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              'Forget your Password?',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            resetErrorMesssage();
                            if (isEmail(emailController.text.trim()) &&
                                passController.text.trim().isNotEmpty) {
                              logIn();
                            } else {
                              setState(() {
                                if (passController.text.trim().isEmpty) {
                                  errorMessageForPassword =
                                  ' You must enter a password!';
                                }
                                if (emailController.text.trim().isEmpty) {
                                  errorMessageForEmail =
                                  'You must enter an email!';
                                } else {
                                  errorMessageForEmail =
                                  'The text entered in the email field is not an email!';
                                }
                              });
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
                                'LOG IN',
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
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                          ),
                          InkWell(
                            onTap: () {
                              GoRouter.of(context).go("/register");
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: myConstants.primaryColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
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
