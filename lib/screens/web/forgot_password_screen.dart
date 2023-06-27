import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/screens/web/responsive_widget.dart';
import 'package:medical_application/utill/helpers.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../models/constants.dart';
import 'app_colors.dart';

class ForgotPasswordWebScreen extends StatefulWidget {
  const ForgotPasswordWebScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordWebScreen> createState() =>
      _ForgotPasswordWebScreenState();
}

class _ForgotPasswordWebScreenState extends State<ForgotPasswordWebScreen> {
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

  var errorMessageForEmail = '';

  void resetErrorMesssage() {
    setState(() {

      errorMessageForEmail = '';

    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Constants myConstants = Constants();
    return BlocListener<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      listenWhen: (oldState, newState) {
        return (oldState.errorMessage != newState.errorMessage);
      },
      listener: (context, state) async {
        setState(() {
          errorMessageForEmail = state.errorMessage!;
        });
      },
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
                          child: const Center(
                            child: Text(
                              'MedicalCare - AdminSystem',
                              style: TextStyle(
                                fontSize: 48.0,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w800,
                              ),
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
                                text: 'Forgot your password?',
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
                          ' Please enter your email\n and we will sent you a password reset link.',
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
                        SizedBox(height: height * 0.03),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                          //    GoRouter.of(context).go("/loginWeb");
                            },
                            child: Text(
                              'Back to login',
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
                              if (isEmail(emailController.text.trim())) {
                                passwordReset();
                                if (errorMessageForEmail!='') {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return  AlertDialog(
                                        title: const Text('Email sent! '),
                                        content: const Text(
                                            'Check your email to reset the password'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              GoRouter.of(context)
                                                  .go("/loginWeb");
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                        elevation: 4.0,
                                      );
                                    },
                                  );
                                }
                              } else {
                                setState(() {
                                  errorMessageForEmail =
                                      'The text entered in the email field is not an email!';
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
                                'Send recovery email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
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
