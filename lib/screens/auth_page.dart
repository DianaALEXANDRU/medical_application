import 'package:flutter/cupertino.dart';
import 'package:medical_application/screens/login_screen.dart';
import 'package:medical_application/screens/register_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (showLoginPage) {
    //   return LoginScreen(showRegisterPage: toggleScreens);
    // } else {
    return RegisterScreen();
    // }
  }
}
