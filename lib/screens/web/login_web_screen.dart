import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';
import 'package:medical_application/utill/helpers.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/medical_bloc.dart';
import '../../models/constants.dart';
import 'app_colors.dart';

class LoginWebScreen extends StatefulWidget {
  const LoginWebScreen({Key? key}) : super(key: key);

  @override
  State<LoginWebScreen> createState() => _LoginWebScreenState();
}

class _LoginWebScreenState extends State<LoginWebScreen> {
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

  var isObscureText=true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();
    if (getIt<AuthBloc>().state.errorMessage != null) {
      errorMessage = getIt<AuthBloc>().state.errorMessage!;
    }

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

            if (role == 'administrator') {
              getIt<MedicalBloc>().add(
                const FetchReviews(),
              );

              GoRouter.of(context).go("/dashboard");
              return;
            }

            FirebaseAuth.instance.signOut();
            setState(() {
              errorMessage='Invalid account!';
            });
            //GoRouter.of(context).go("/loginWeb");
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
        backgroundColor: AppColors.backColor,
        body: SizedBox(
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? const SizedBox()
                  : Expanded(
                      child: SizedBox(
                        height: height,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: myConstants.linearGradientBlue,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'MediBooking',
                                  style: TextStyle(
                                    fontSize: 48.0,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'Smart medical solution',
                                  style: TextStyle(
                                    fontSize: 48.0,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                  height: height,
                  margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.isSmallScreen(context)
                          ? height * 0.032
                          : height * 0.12),
                  color: AppColors.backColor,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.2),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Welcome back,',
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: AppColors.blueDarkColor,
                                    fontWeight: FontWeight.normal,
                                  )),
                              TextSpan(
                                text: ' Log In.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.blueDarkColor,
                                  fontSize: 25.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        const Text(
                          'Please enter your details to log in \nto your account.',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: height * 0.064),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            controller: emailController,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.email_outlined,
                                    color: myConstants.primaryColor),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter Email',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
                              ),
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
                        SizedBox(height: height * 0.014),
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            controller: passController,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            obscureText: isObscureText? true : false,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if(isObscureText){
                                      isObscureText=false;
                                    }else{
                                      isObscureText=true;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: myConstants.primaryColor,
                                ),
                              ),
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.lock_outline,
                                  color: myConstants.primaryColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter Password',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
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
                        SizedBox(height: height * 0.03),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              GoRouter.of(context).go("/resetPasswordWeb");
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: myConstants.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
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
                            borderRadius: BorderRadius.circular(16.0),
                            child: Ink(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 70.0, vertical: 18.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: myConstants.primaryColor,
                              ),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
