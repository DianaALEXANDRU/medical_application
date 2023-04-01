import 'package:flutter/material.dart';
import 'package:medical_application/models/constants.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Size size;

  const GradientButton({
    Key? key,
    required this.text,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants();
    return SizedBox(
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
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
