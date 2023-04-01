import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CategoryEntity extends Equatable {
  static const String fieldName = 'name';
  static const String fieldImageUrl = 'url';

  final String name;
  final String url;

  const CategoryEntity({
    required this.name,
    required this.url,
  });

  static CategoryEntity fromJson(Map<String, dynamic> json) => CategoryEntity(
        name: json[fieldName],
        url: json[fieldImageUrl] ?? '',
      );

  Map<String, dynamic> toJson() => {
        fieldName: name,
        fieldImageUrl: url,
      };

  @override
  List<Object> get props => [
        name,
        url,
      ];
}
