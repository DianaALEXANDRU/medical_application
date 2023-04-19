import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/bloc/auth/auth_bloc.dart';
import 'package:medical_application/bloc/medical_bloc.dart';
import 'package:medical_application/main.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
import 'package:medical_application/models/constants.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/screens/confirm_appointment_screen.dart';
import 'package:medical_application/utill/helpers.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const BookAppointmentScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();
    List<Appointment> appointments = [];
    List<AppointmentHours> freeSlots = [];
    List<int> programDays = [];

    getIt<MedicalBloc>().add(
      FetchProgramDays(
        doctorId: widget.doctor.id,
      ),
    );
    getIt<MedicalBloc>().add(
      FetchFreeHours(
        doctorId: widget.doctor.id,
        date: _selectedDay,
      ),
    );

    void findNextDay(List<int> programDays) async {
      //var programDays=getIt<MedicalBloc>().state.programDays;
      var nextDay = _selectedDay;
      while (isDayInProgram(programDays, nextDay) == false) {
        nextDay = _selectedDay.add(const Duration(days: 1));
      }

      setState(() {
        _selectedDay = nextDay;
      });
    }

    void setProgramDays(List<int> pDays) {
      programDays = pDays;
    }

    return BlocBuilder<AuthBloc, AuthState>(
      bloc: getIt<AuthBloc>(),
      builder: (context, authState) {
        return BlocBuilder<MedicalBloc, MedicalState>(
          bloc: getIt<MedicalBloc>(),
          builder: (context, medicalState) {
            //appointments= medicalState.appointmentsByDoctor;
            //print("/////////////////////APP : ${appointments.length}");
            DateTime date = DateTime.now();
            freeSlots = medicalState.freeHours;
            //setProgramDays(medicalState.programDays);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: myConstants.primaryColor,
                centerTitle: true,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              body: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        if (day.weekday == DateTime.sunday ||
                            day.weekday == DateTime.saturday) {
                          final text = DateFormat.E().format(day);
                          return Center(
                            child: Text(
                              text,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return null;
                      },
                      selectedBuilder: (context, date, events) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      todayBuilder: (context, date, events) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${date.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(
                          () {
                            _calendarFormat = format;
                          },
                        );
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                  if (freeSlots.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: freeSlots.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(freeSlots[index].startHour),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfirmAppointmentScreen(
                                        patientId: authState.user!.id,
                                        doctor: widget.doctor,
                                        date: _selectedDay,
                                        hour: freeSlots[index].startHour,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (freeSlots.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          const Divider(),
                          const SizedBox(
                            height: 48,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Image.asset(
                              'assets/images/calendar.png',
                              width: size.width / 3,
                              height: size.height / 6,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                              'We are sorry, there is no available time on this day.'),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            width: size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                              ),
                              child: InkWell(
                                onTap: () {
                                  //verifica daca merge asa adica sa ia tpate app doctorului respectiv si abia dupa sa treaca la pagina urmatoare
                                  // findNextDay(programDays);
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    color: myConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Container(
                                    width: size.width * 0.9,
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Find next day',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
