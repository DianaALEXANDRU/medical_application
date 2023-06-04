import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'main_page.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  Future passwordReset() async {
    getIt<AuthBloc>().add(
      PasswordReset(
        email: emailController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "################################### ${GoRouter.of(context).location} ");
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    var showMessage = false;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              GoRouter.of(context).go("/login");
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
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
                top: 300,
              ),
              child: const Text(
                'Enter yout email and we will\nsent you a password reset link.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 372,
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
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        passwordReset().then((value) {
                          showMessage = true;
                        });
                        if (showMessage = true) {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Email sent! '),
                                content: const Text(
                                    'Check your email to reset the password'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MainPage(),
                                        ),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                                elevation: 4.0,
                              );
                            },
                          );
                        }
                        showMessage = false;
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
                            'RESET PASSWORD',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
