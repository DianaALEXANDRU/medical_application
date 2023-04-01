import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class Utility {
  static DateTime stringToDateTime(String dateString) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime date = formatter.parse(dateString);

    return date;
  }

  static TimeOfDay stringToTimeOfDay(String timeString) {
    final format = DateFormat.Hm();
    final time = format.parse(timeString);
    return TimeOfDay.fromDateTime(time);
  }

  static String formatTimeOfDay(TimeOfDay time) {
    String hour = (time.hour < 10) ? '0${time.hour}' : '${time.hour}';
    String minute = (time.minute < 10) ? '0${time.minute}' : '${time.minute}';
    return '$hour:$minute';
  }
}
