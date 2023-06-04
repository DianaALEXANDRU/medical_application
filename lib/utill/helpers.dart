import 'package:intl/intl.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/repositories/rest/medical_repository.dart';

var medicalRepository = MedicalRestRepository();

Doctor? findDoctorById(List<Doctor> doctors, String doctorId) {
  for (var doctor in doctors) {
    if (doctor.id == doctorId) {
      return doctor;
    }
  }
  return null;
}

UserClass? findUserById(String patientId) {
  List<UserClass> users = getIt<MedicalBloc>().state.users;
  for (var patient in users) {
    if (patient.id == patientId) {
      return patient;
    }
  }
  return null;
}

List<Review> findReviewsByDoctorId(List<Review> allReviews, String doctorId) {
  List<Review> doctorReviews = [];
  doctorReviews =
      allReviews.where((review) => review.doctorId == doctorId).toList();

  return doctorReviews;
}

bool hasAppointmentConfirmedBefore(
    List<Appointment> allAppointments, String doctorId) {
  for (var app in allAppointments) {
    if (app.doctorId == doctorId &&
        app.dateAndTime.isBefore(DateTime.now()) &&
        app.confirmed == true) {
      return true;
    }
  }
  return false;
}

void addReview(int stars, String comment, String doctorId, String userId) {
  medicalRepository.addReview(comment, stars, doctorId, userId);
}

String getDayOfWeek(int dayNumber) {
  switch (dayNumber) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
    default:
      return "Invalid day number";
  }
}

int getDayNumber(String dayOfWeek) {
  switch (dayOfWeek.toLowerCase()) {
    case "monday":
      return 1;
    case "tuesday":
      return 2;
    case "wednesday":
      return 3;
    case "thursday":
      return 4;
    case "friday":
      return 5;
    case "saturday":
      return 6;
    case "sunday":
      return 7;
    default:
      return -1;
  }
}

List<AppointmentHours> sortProgram(List<AppointmentHours> hours) {
  hours.sort((a, b) => a.startHour.compareTo(b.startHour));
  return hours;
}

String extractDate(DateTime dateAndTime) {
  String formattedDate = DateFormat("dd/MM/yyyy").format(dateAndTime);
  return formattedDate;
}

List<AppointmentHours> getFreeSlots(List<Appointment> appointments,
    DateTime date, Map<int, List<AppointmentHours>> program) {
  List<AppointmentHours> slots = [];
  int day = getDayNumber(DateFormat('EEEE').format(date));

  if (program.containsKey(day)) {
    var listApp = getAppByDate(appointments, date);
    var listHours = sortProgram(program[day]!);
    for (var hour in listHours) {
      if (findHourInAppList(listApp, hour.startHour) == false) {
        slots.add(hour);
      }
    }
  } else {
    return [];
  }
  return slots;
}

List<Appointment> getAppByDate(List<Appointment> appointments, DateTime date) {
  List<Appointment> listApp = [];

  for (var app in appointments) {
    if (DateFormat("dd/MM/yyyy").format(app.dateAndTime) ==
        DateFormat("dd/MM/yyyy").format(date)) {
      listApp.add(app);
    }
  }

  return listApp;
}

bool findHourInAppList(List<Appointment> appointments, String startHour) {
  for (var app in appointments) {
    if (DateFormat("hh:mm").format(app.dateAndTime) == startHour) {
      return true;
    }
  }
  return false;
}

bool isDayInProgram(List<int> programDays, DateTime day) {
  var dayNumber = getDayNumber(DateFormat.EEEE().format(day));
  if (programDays.contains(dayNumber)) {
    return true;
  }

  return false;
}

int existingDoctorsByCategory(List<Doctor> doctors, String category) {
  int doctorsNr = 0;
  for (var doctor in doctors) {
    if (doctor.category == category) {
      doctorsNr++;
    }
  }
  return doctorsNr;
}

List<String> makeCategoryFilters(List<Category> categories) {
  List<String> filters = [];
  filters.add('All categories');
  for (var cat in categories) {
    filters.add(cat.name);
  }

  return filters;
}

Doctor? findDoctor(List<Doctor> doctors, String doctorId) {
  for (var doc in doctors) {
    if (doc.id == doctorId) {
      return doc;
    }
  }
  return null;
}

List<Appointment> todaysAppointments(List<Appointment> appointments) {
  List<Appointment> todayApps = [];
  for (var app in appointments) {
    if (DateFormat("dd/MM/yyyy").format(app.dateAndTime) ==
        DateFormat("dd/MM/yyyy").format(DateTime.now())) {
      todayApps.add(app);
    }
  }

  return todayApps;
}
