part of 'medical_bloc.dart';

class MedicalState extends Equatable {
  final List<Doctor> doctors;
  final List<Category> categories;
  final List<Appointment> appointments;

  MedicalState({
    required List<Doctor> doctors,
    required List<Category> categories,
    required List<Appointment> appointments,
  })  : doctors = List.unmodifiable(doctors),
        categories = List.unmodifiable(categories),
        appointments = List.unmodifiable(appointments);

  MedicalState copyWith({
    List<Doctor>? doctors,
    List<Category>? categories,
    List<Appointment>? appointments,
  }) {
    return MedicalState(
      doctors: doctors ?? this.doctors,
      categories: categories ?? this.categories,
      appointments: appointments ?? this.appointments,
    );
  }

  @override
  String toString() => 'MedicalState(${categories.length})';

  @override
  List<Object?> get props => [
        doctors,
        categories,
        appointments,
      ];
}
