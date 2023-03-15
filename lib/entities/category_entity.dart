import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CategoryEntity extends Equatable {
  //static const String fieldId = 'id';
  static const String fieldName = 'name';
  static const String fieldImageUrl = 'url';

  // final int id;
  final String name;
  final String url;

  const CategoryEntity({
    // required this.id,
    required this.name,
    required this.url,
  });

  static CategoryEntity fromJson(Map<String, dynamic> json) => CategoryEntity(
        //  id: json[fieldId],
        name: json[fieldName],
        url: json[fieldImageUrl] ?? '',
      );

  Map<String, dynamic> toJson() => {
        // fieldId: id,
        fieldName: name,
        fieldImageUrl: url,
      };

  @override
  List<Object> get props => [
        // id,
        name,
        url,
      ];
}
