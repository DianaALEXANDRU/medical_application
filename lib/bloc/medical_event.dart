part of 'medical_bloc.dart';

abstract class MedicalEvent extends Equatable {
  const MedicalEvent();
}

class FetchDoctors extends MedicalEvent {
  const FetchDoctors();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchAvailableDoctors extends MedicalEvent {
  const FetchAvailableDoctors();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchUsers extends MedicalEvent {
  const FetchUsers();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchCategories extends MedicalEvent {
  const FetchCategories();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchAllAppointments extends MedicalEvent {
  const FetchAllAppointments();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchAppointmentsForUser extends MedicalEvent {
  final String userId;

  const FetchAppointmentsForUser({required this.userId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userId];
}

class FetchAppointmentsForDoctor extends MedicalEvent {
  final String userId;

  const FetchAppointmentsForDoctor({required this.userId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userId];
}

class FetchReviews extends MedicalEvent {
  const FetchReviews();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class FetchReviewsByDoctorId extends MedicalEvent {
  final String doctorId;

  const FetchReviewsByDoctorId({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class AddReview extends MedicalEvent {
  final int stars;
  final String comment;
  final String doctorId;
  final String userId;

  const AddReview(
      {required this.stars,
      required this.comment,
      required this.doctorId,
      required this.userId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        stars,
        comment,
        doctorId,
        userId,
      ];
}

class FetchFreeHours extends MedicalEvent {
  final String doctorId;
  final DateTime date;

  const FetchFreeHours({required this.doctorId, required this.date});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId, date];
}

class FetchProgramDays extends MedicalEvent {
  final String doctorId;

  const FetchProgramDays({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class FetchProgram extends MedicalEvent {
  final String doctorId;

  const FetchProgram({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class FetchProgramList extends MedicalEvent {
  final String doctorId;

  const FetchProgramList({required this.doctorId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [doctorId];
}

class ConfirmeAppointment extends MedicalEvent {
  final String appointmentId;

  const ConfirmeAppointment({required this.appointmentId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [appointmentId];
}

class DeleteAppointment extends MedicalEvent {
  final String appointmentId;

  const DeleteAppointment({required this.appointmentId});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [appointmentId];
}

class AddAppointment extends MedicalEvent {
  final String patientId;
  final String doctorId;
  final String hour;
  final DateTime date;

  const AddAppointment({
    required this.patientId,
    required this.doctorId,
    required this.date,
    required this.hour,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        patientId,
        doctorId,
        date,
        hour,
      ];
}

class EditUserDetails extends MedicalEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String phoneNo;

  const EditUserDetails({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phoneNo,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        phoneNo,
      ];
}

class MakeDoctor extends MedicalEvent {
  final String userId;
  final String category;
  final String experience;
  final String description;
  final List<Program> program;
  final String selctFile;
  final Uint8List? selectedImageInBytes;

  const MakeDoctor({
    required this.userId,
    required this.category,
    required this.experience,
    required this.description,
    required this.program,
    required this.selctFile,
    required this.selectedImageInBytes,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        userId,
        category,
        experience,
        description,
        program,
        selctFile,
        selectedImageInBytes,
      ];
}

class AddCategory extends MedicalEvent {
  final String name;
  final String selctFile;
  final Uint8List? selectedImageInBytes;

  const AddCategory({
    required this.name,
    required this.selctFile,
    required this.selectedImageInBytes,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        name,
        selctFile,
        selectedImageInBytes,
      ];
}

class EditCategory extends MedicalEvent {
  final String name;
  final String selctFile;
  final Uint8List? selectedImageInBytes;
  final Category category;

  const EditCategory({
    required this.name,
    required this.selctFile,
    required this.selectedImageInBytes,
    required this.category,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        name,
        selctFile,
        selectedImageInBytes,
        category,
      ];
}

class EditProfilePicture extends MedicalEvent {
  final String doctorId;
  final String selctFile;
  final Uint8List? selectedImageInBytes;

  const EditProfilePicture({
    required this.doctorId,
    required this.selctFile,
    required this.selectedImageInBytes,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        doctorId,
        selctFile,
        selectedImageInBytes,
      ];
}

class EditDoctorDetails extends MedicalEvent {
  final Doctor doctor;
  final String category;
  final String experience;
  final String description;

  const EditDoctorDetails({
    required this.doctor,
    required this.category,
    required this.experience,
    required this.description,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        doctor,
        category,
        experience,
        description,
      ];
}

class EditDoctorAvailability extends MedicalEvent {
  final String doctorId;
  final String availability;

  const EditDoctorAvailability({
    required this.doctorId,
    required this.availability,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        doctorId,
        availability,
      ];
}

class DeleteCategory extends MedicalEvent {
  final Category category;

  const DeleteCategory({required this.category});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [category];
}

class DeleteProgram extends MedicalEvent {
  final String doctorId;
  final String day;
  final String start;
  final String end;

  const DeleteProgram({
    required this.doctorId,
    required this.day,
    required this.start,
    required this.end,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        doctorId,
        day,
        start,
        end,
      ];
}

class AddOneProgram extends MedicalEvent {
  final String doctorId;
  final Program program;

  const AddOneProgram({
    required this.doctorId,
    required this.program,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        doctorId,
        program,
      ];
}
