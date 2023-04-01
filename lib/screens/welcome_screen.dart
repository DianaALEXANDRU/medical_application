import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: size.width * 0.4,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                top: size.height * 0.25,
                right: size.width * 0.1,
                left: size.width * 0.1,
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/welcome.png'),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: size.height * 0.7,
                right: size.width * 0.1,
                left: size.width * 0.1,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: myConstants.linearGradientBlue,
                        ),
                        child: Container(
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
                    height: 25,
                  ),
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {},
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
