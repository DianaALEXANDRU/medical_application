import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class DoctorEntity extends Equatable {
  static const String fieldId = 'id';
  static const String fieldName = 'name';
  static const String fieldImageUrl = 'image_url';
  static const String fieldDescription = 'description';
  static const String fieldCategory = 'category';
  static const String fieldRating = 'rating';

  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String category;
  final String rating;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.rating,
  });

  static DoctorEntity fromJson(Map<String, dynamic> json) => DoctorEntity(
      id: json[fieldId],
      name: json[fieldName],
      imageUrl: json[fieldImageUrl] ?? '',
      description: json[fieldDescription] ?? '',
      category: json[fieldCategory] ?? '',
      rating: json[fieldRating] ?? '');

  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldName: name,
        fieldImageUrl: imageUrl,
        fieldDescription: description,
        fieldCategory: category,
        fieldRating: rating,
      };

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
