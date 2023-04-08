part of 'medical_bloc.dart';

class MedicalState extends Equatable {
  final List<Doctor> doctors;
  final List<Category> categories;
  final List<Appointment> appointments;
  final List<Review> reviews;
  final List<UserClass> users;

  MedicalState({
    required List<Doctor> doctors,
    required List<Category> categories,
    required List<Appointment> appointments,
    required List<Review> reviews,
    required List<UserClass> users,
  })  : doctors = List.unmodifiable(doctors),
        categories = List.unmodifiable(categories),
        appointments = List.unmodifiable(appointments),
        reviews = List.unmodifiable(reviews),
        users = List.unmodifiable(users);

  MedicalState copyWith({
    List<Doctor>? doctors,
    List<Category>? categories,
    List<Appointment>? appointments,
    List<Review>? reviews,
    List<UserClass>? users,
  }) {
    return MedicalState(
      doctors: doctors ?? this.doctors,
      categories: categories ?? this.categories,
      appointments: appointments ?? this.appointments,
      reviews: reviews ?? this.reviews,
      users: users ?? this.users,
    );
  }

  @override
  String toString() => 'MedicalState(${categories.length})';

  @override
  List<Object?> get props => [
        doctors,
        categories,
        appointments,
        reviews,
        users,
      ];
}
