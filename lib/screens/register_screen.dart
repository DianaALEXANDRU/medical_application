import 'package:flutter/material.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/constants.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginPage;

  const RegisterScreen({Key? key, required this.showLoginPage})
      : super(key: key);

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

  Future register() async {
    if (passwordConfirmed()) {
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
    return Scaffold(
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
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                      height: 48.0,
                      child: ElevatedButton(
                        onPressed: () {
                          register();
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                        ),
                        InkWell(
                          onTap: widget.showLoginPage,
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
    );
  }
}
