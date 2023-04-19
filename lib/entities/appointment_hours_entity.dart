import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class AppointmentHoursEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldStartHour = 'start_hour';
  static const String fieldEndHour = 'end_hour';

  final String id;
  final String startHour;
  final String endHour;

  const AppointmentHoursEntity({
    required this.id,
    required this.startHour,
    required this.endHour,
  });

  static AppointmentHoursEntity fromJson(Map<String, dynamic> json) =>
      AppointmentHoursEntity(
        id: json[fieldId],
        startHour: json[fieldStartHour],
        endHour: json[fieldEndHour],
      );

  Map<String, dynamic> toJson() =>
      {fieldId: id, fieldStartHour: startHour, fieldEndHour: endHour};

  @override
  List<Object> get props => [
        id,
        startHour,
        endHour,
      ];
}
