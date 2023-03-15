import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/doctor_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Doctor extends Equatable {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String category;
  final String rating;

  const Doctor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.rating,
  });

  static Doctor fromEntity(DoctorEntity entity) => Doctor(
        id: entity.id,
        name: entity.name,
        imageUrl: entity.imageUrl,
        description: entity.description,
        category: entity.category,
        rating: entity.rating,
      );

  DoctorEntity toEntity() => DoctorEntity(
        id: id,
        name: name,
        imageUrl: imageUrl,
        description: description,
        category: category,
        rating: rating,
      );

  @override
  String toString() => '$name($id)';

  @override
  List<Object> get props => [
        id,
        name,
        imageUrl,
        description,
        category,
        rating,
      ];
}
