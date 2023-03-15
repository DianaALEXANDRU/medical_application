import 'package:equatable/equatable.dart';
import 'package:medical_application/entities/category_entity.dart';
import 'package:meta/meta.dart';

@immutable
class Category extends Equatable {
  // final int id;
  final String name;
  final String url;

  const Category({
    //  required this.id,
    required this.name,
    required this.url,
  });

  static Category fromEntity(CategoryEntity entity) => Category(
        //   id: entity.id,
        name: entity.name,
        url: entity.url,
      );

  CategoryEntity toEntity() => CategoryEntity(
        //  id: id,
        name: name,
        url: url,
      );

  @override
  String toString() => '$name($name)';

  @override
  List<Object> get props => [
        // id,
        name,
        url,
      ];
}
