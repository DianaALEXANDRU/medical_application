import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:medical_application/models/appointment.dart';
import 'package:medical_application/models/appointment_hours.dart';
import 'package:medical_application/models/category.dart';
import 'package:medical_application/models/doctor.dart';
import 'package:medical_application/models/programDto.dart';
import 'package:medical_application/models/review.dart';
import 'package:medical_application/models/user.dart';
import 'package:medical_application/repositories/medical_repository.dart';

import '../utill/helpers.dart';

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
            appointmentsByDoctor: const [],
            reviews: const [],
            users: const [],
            freeHours: const [],
            programDays: const [],
            program: const {},
          ),
        ) {
    on<FetchDoctors>(_handleFetchDoctors);
    on<FetchCategories>(_handleFetchCategories);
    on<FetchUsers>(_handleFetchUsers);
    on<FetchAllAppointments>(_handleFetchAllAppointments);
    on<FetchAppointmentsForUser>(_handleFetchAppointmentsForUser);
    on<FetchAppointmentsForDoctor>(_handleFetchAppointmentsForDoctor);
    on<FetchReviews>(_handleFetchReviews);
    on<FetchReviewsByDoctorId>(_handleFetchReviewsByDoctorId);
    on<ConfirmeAppointment>(_handleConfirmeAppointment);
    on<DeleteAppointment>(_handleDeleteAppointment);
    on<EditUserDetails>(_handleEditUserDetails);
    on<FetchFreeHours>(_handleFetchFreeHours);
    on<AddAppointment>(_handleAddAppointment);
    on<FetchProgramDays>(_handleFetchProgramDays);
    on<FetchProgram>(_handleFetchProgram);

    on<MakeDoctor>(_handleMakeDoctor);

    on<AddCategory>(_handleAddCategory);
    on<EditCategory>(_handleEditCategory);
    on<DeleteCategory>(_handleDeleteCategory);
    // on<DeleteCategory>(_handleDeleteCategory);
    on<EditProfilePicture>(_handleEditProfilePicture);
    on<EditDoctorDetails>(_handleEditDoctorDetails);
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

  Future<void> _handleFetchUsers(
    FetchUsers event,
    Emitter<MedicalState> emit,
  ) async {
    List<UserClass> users = await medicalRepository.fetchUsers();
    emit(
      state.copyWith(
        users: users,
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

  Future<void> _handleFetchAllAppointments(
    FetchAllAppointments event,
    Emitter<MedicalState> emit,
  ) async {
    List<Appointment> appointments =
        await medicalRepository.fetchAllAppointments();
    emit(
      state.copyWith(
        appointments: appointments,
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
        appointmentsByDoctor: appointments,
      ),
    );
  }

  Future<void> _handleFetchProgramDays(
    FetchProgramDays event,
    Emitter<MedicalState> emit,
  ) async {
    emit(
      state.copyWith(
        programDays: [],
      ),
    );
    List<int> programDays =
        await medicalRepository.fetchProgramDays(event.doctorId);
    programDays.sort();
    emit(
      state.copyWith(
        programDays: programDays,
      ),
    );
  }

  Future<void> _handleFetchProgram(
    FetchProgram event,
    Emitter<MedicalState> emit,
  ) async {
    emit(
      state.copyWith(
        program: {},
      ),
    );
    Map<int, List<AppointmentHours>> program =
        await medicalRepository.fetchProgram(event.doctorId);

    Map<int, List<AppointmentHours>> sortedProgram = {};

    program.forEach((day, hoursList) {
      hoursList.sort((a, b) => a.startHour.compareTo(b.startHour));
      sortedProgram[day] = hoursList;
    });

    emit(
      state.copyWith(
        program: sortedProgram,
      ),
    );
  }

  Future<void> _handleFetchFreeHours(
    FetchFreeHours event,
    Emitter<MedicalState> emit,
  ) async {
    emit(
      state.copyWith(
        appointmentsByDoctor: [],
        freeHours: [],
      ),
    );
    List<Appointment> appointments =
        await medicalRepository.fetchAppointmentsForDoctor(event.doctorId);
    Map<int, List<AppointmentHours>> program =
        await medicalRepository.fetchProgram(event.doctorId);

    List<AppointmentHours> slots = [];

    int day = getDayNumber(DateFormat('EEEE').format(event.date));

    if (program.containsKey(day)) {
      if (event.date.isAfter(DateTime.now()) ||
          DateFormat("dd/mm/yyyy").format(event.date) ==
              DateFormat("dd/mm/yyyy").format(DateTime.now())) {
        var listApp = getAppByDate(appointments, event.date);
        var listHours = sortProgram(program[day]!);
        for (var hour in listHours) {
          if (findHourInAppList(listApp, hour.startHour) == false &&
              hour.startHour.compareTo(DateFormat('HH:mm').format(event.date)) >
                  0) {
            slots.add(hour);
          }
        }
      }
    }
    emit(
      state.copyWith(
        freeHours: slots,
      ),
    );
  }

  Future<void> _handleFetchReviews(
    FetchReviews event,
    Emitter<MedicalState> emit,
  ) async {
    List<Review> reviews = await medicalRepository.fetchReviews();
    emit(
      state.copyWith(
        reviews: reviews,
      ),
    );
  }

  Future<void> _handleFetchReviewsByDoctorId(
    FetchReviewsByDoctorId event,
    Emitter<MedicalState> emit,
  ) async {
    List<Review> reviews =
        await medicalRepository.fetchReviewByDoctorId(event.doctorId);
    emit(
      state.copyWith(
        reviews: reviews,
      ),
    );
  }

  Future<void> _handleConfirmeAppointment(
    ConfirmeAppointment event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.confirmeAppointment(
      event.appointmentId,
    );
  }

  Future<void> _handleDeleteAppointment(
    DeleteAppointment event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.deleteAppointment(
      event.appointmentId,
    );
  }

  Future<void> _handleEditUserDetails(
    EditUserDetails event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.editUserDetails(
      event.userId,
      event.firstName,
      event.lastName,
      event.phoneNo,
    );
  }

  Future<void> _handleAddAppointment(
    AddAppointment event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.makeAppointment(
      event.patientId,
      event.doctorId,
      event.date,
      event.hour,
    );
  }

  Future<void> _handleMakeDoctor(
    MakeDoctor event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.makeDoctor(
      event.userId,
      event.category,
      event.experience,
      event.description,
      event.program,
      event.selctFile,
      event.selectedImageInBytes,
    );

    List<Doctor> doctors = await medicalRepository.fetchDoctors();
    emit(
      state.copyWith(
        doctors: doctors,
      ),
    );
  }

  Future<void> _handleAddCategory(
    AddCategory event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.addCategory(
      event.name,
      event.selctFile,
      event.selectedImageInBytes,
    );
  }

  Future<void> _handleEditCategory(
    EditCategory event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.editCategory(
      event.name,
      event.selctFile,
      event.selectedImageInBytes,
      event.category,
    );

    List<Category> categories = await medicalRepository.fetchCategories();
    emit(
      state.copyWith(
        categories: categories,
      ),
    );
  }

  Future<void> _handleDeleteCategory(
    DeleteCategory event,
    Emitter<MedicalState> emit,
  ) async {
    await medicalRepository.deleteCategory(
      event.category,
    );
  }

  Future<void> _handleEditProfilePicture(
      EditProfilePicture event,
      Emitter<MedicalState> emit,
      ) async {
    await medicalRepository.editProfilePicture(
      event.doctorId,
      event.selctFile,
      event.selectedImageInBytes
    );

    List<Doctor> doctors = await medicalRepository.fetchDoctors();
    emit(
      state.copyWith(
        doctors: doctors,
      ),
    );
  }

  Future<void> _handleEditDoctorDetails(
      EditDoctorDetails event,
      Emitter<MedicalState> emit,
      ) async {

    await medicalRepository.editDoctorDetails(
      event.doctor,
      event.category,
      event.experience,
      event.description,
    );

    List<Doctor> doctors = await medicalRepository.fetchDoctors();
    emit(
      state.copyWith(
        doctors: doctors,
      ),
    );
  }
}
