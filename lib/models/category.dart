import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/category_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Category extends Equatable {
  final String name;
  final String url;

  const Category({
    required this.name,
    required this.url,
  });

  static Category fromEntity(CategoryEntity entity) => Category(
        name: entity.name,
        url: entity.url,
      );

  CategoryEntity toEntity() => CategoryEntity(
        name: name,
        url: url,
      );

  @override
  String toString() => '$name($name)';

  @override
  List<Object> get props => [
        name,
        url,
      ];
}
