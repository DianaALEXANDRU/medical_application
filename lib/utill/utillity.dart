import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Utility {
  static DateTime combineDateAndTime(String date, String time) {
    DateTime dateAndTime =
        DateFormat("dd/MM/yyyy hh:mm").parse(date + ' ' + time);
    return dateAndTime;
  }

  static String extractTime(DateTime dateAndTime) {
    String formattedTime = DateFormat.Hm().format(dateAndTime);
    return formattedTime;
  }

  static String extractDate(DateTime dateAndTime) {
    String formattedDate = DateFormat("dd/MM/yyyy").format(dateAndTime);
    return formattedDate;
  }
}
