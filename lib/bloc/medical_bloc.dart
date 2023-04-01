import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/repositories/medical_repository.dart';

part 'medical_event.dart';

part 'medical_state.dart';

class MedicalBloc extends Bloc<MedicalEvent, MedicalState> {
  final MedicalRepository medicalRepository;

  MedicalBloc({
    required this.medicalRepository,
  }) : super(
          MedicalState(
            doctors: const [],
            categories: const [],
            appointments: const [],
          ),
        ) {
    on<FetchDoctors>(_handleFetchDoctors);
    on<FetchCategories>(_handleFetchCategories);
    on<FetchAppointmentsForUser>(_handleFetchAppointmentsForUser);
    on<FetchAppointmentsForDoctor>(_handleFetchAppointmentsForDoctor);
  }

  Future<void> _handleFetchDoctors(
    FetchDoctors event,
    Emitter<MedicalState> emit,
  ) async {
    List<Doctor> doctors = await medicalRepository.fetchDoctors();
    emit(
      state.copyWith(
        doctors: doctors,
      ),
    );
  }

  Future<void> _handleFetchCategories(
    FetchCategories event,
    Emitter<MedicalState> emit,
  ) async {
    List<Category> categories = await medicalRepository.fetchCategories();
    emit(
      state.copyWith(
        categories: categories,
      ),
    );
  }

  Future<void> _handleFetchAppointmentsForUser(
    FetchAppointmentsForUser event,
    Emitter<MedicalState> emit,
  ) async {
    List<Appointment> appointments =
        await medicalRepository.fetchAppointmentsForUser(event.userId);
    emit(
      state.copyWith(
        appointments: appointments,
      ),
    );
  }

  Future<void> _handleFetchAppointmentsForDoctor(
    FetchAppointmentsForDoctor event,
    Emitter<MedicalState> emit,
  ) async {
    List<Appointment> appointments =
        await medicalRepository.fetchAppointmentsForDoctor(event.userId);
    emit(
      state.copyWith(
        appointments: appointments,
      ),
    );
  }
}
