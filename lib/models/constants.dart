import 'package:flutter/material.dart';

class Constants {
  final primaryColor = const Color(0xff38B6FF);
  final secondaryColor = const Color(0xff52CBBE);
  final tertiaryColor = const Color(0xffeef0f2);
  final blackColor = const Color(0xff1a1d26);

  final greyColor = const Color(0xffd9dadb);

  final contrastColor = const Color(0xffe7effa);

  final Shader shader = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  final linearGradientBlue = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff38B6FF), Color(0xff52CBBE)],
      stops: [0.0, 1.0]);
  final linearGradientPurple = const LinearGradient(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
      colors: [Color(0xff51087E), Color(0xff6C0BA9)],
      stops: [0.0, 1.0]);
}
