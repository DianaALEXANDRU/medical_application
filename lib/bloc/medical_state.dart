part of 'medical_bloc.dart';

class MedicalState extends Equatable {
  final List<Doctor> doctors;
  final List<Category> categories;
  final List<Appointment> appointments;
  final List<Appointment> appointmentsByDoctor;
  final List<Review> reviews;
  final List<UserClass> users;
  final List<AppointmentHours> freeHours;
  final List<int> programDays;
  final Map<int, List<AppointmentHours>> program;

  MedicalState({
    required List<Doctor> doctors,
    required List<Category> categories,
    required List<Appointment> appointments,
    required List<Appointment> appointmentsByDoctor,
    required List<Review> reviews,
    required List<UserClass> users,
    required List<AppointmentHours> freeHours,
    required List<int> programDays,
    required this.program,
  })  : doctors = List.unmodifiable(doctors),
        categories = List.unmodifiable(categories),
        appointments = List.unmodifiable(appointments),
        appointmentsByDoctor = List.unmodifiable(appointmentsByDoctor),
        reviews = List.unmodifiable(reviews),
        users = List.unmodifiable(users),
        freeHours = List.unmodifiable(freeHours),
        programDays = List.unmodifiable(programDays);

  MedicalState copyWith({
    List<Doctor>? doctors,
    List<Category>? categories,
    List<Appointment>? appointments,
    List<Appointment>? appointmentsByDoctor,
    List<Review>? reviews,
    List<UserClass>? users,
    List<AppointmentHours>? freeHours,
    List<int>? programDays,
    Map<int, List<AppointmentHours>>? program,
  }) {
    return MedicalState(
      doctors: doctors ?? this.doctors,
      categories: categories ?? this.categories,
      appointments: appointments ?? this.appointments,
      appointmentsByDoctor: appointmentsByDoctor ?? this.appointmentsByDoctor,
      reviews: reviews ?? this.reviews,
      users: users ?? this.users,
      freeHours: freeHours ?? this.freeHours,
      programDays: programDays ?? this.programDays,
      program: program ?? this.program,
    );
  }

  @override
  String toString() => 'MedicalState(${categories.length})';

  @override
  List<Object?> get props => [
        doctors,
        categories,
        appointments,
        appointmentsByDoctor,
        reviews,
        users,
        freeHours,
        programDays,
        program,
      ];
}
