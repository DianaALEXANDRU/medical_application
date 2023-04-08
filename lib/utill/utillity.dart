import 'package:intl/intl.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/review.dart';

abstract class Utility {
  //TODO sterg clasa si static
  static DateTime combineDateAndTime(String date, String time) {
    DateTime dateAndTime = DateFormat("dd/MM/yyyy hh:mm").parse('$date $time');
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

  static Map<int, int> createStarsList(List<Review> allReviews) {
    Map<int, int> stars = {
      5: 0,
      4: 0,
      3: 0,
      2: 0,
      1: 0,
    };
    for (var r in allReviews) {
      stars.update(r.stars, (value) => value + 1);
    }

    return stars;
  }

  static double? rating(List<Review> allReviews) {
    double media = 0.0;
    Map<int, int> starList = createStarsList(allReviews);

    var star1 = starList[1];
    var star2 = starList[2];
    var star3 = starList[3];
    var star4 = starList[4];
    var star5 = starList[5];

    var total = (star1! + star2! + star3! + star4! + star5!);
    var sum =
        (star1 * 1 + star2 * 2 + star3 * 3 + star4 * 4 + star5 * 5).toDouble();
    media = sum.toDouble() / total;

    return media;
  }

  static void sortListByDateTime(List<Appointment> list) {
    list.sort((a, b) => a.dateAndTime.compareTo(b.dateAndTime));
  }

  static bool compareDates(DateTime date1, DateTime date2) {
    if (date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year) {
      return true;
    }
    return false;
  }
}
