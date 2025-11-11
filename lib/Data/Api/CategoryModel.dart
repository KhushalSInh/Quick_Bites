// CategoryModel.dart
import 'package:hive/hive.dart';

part 'CategoryModel.g.dart';

@HiveType(typeId: 5) // New typeId for categories
class FoodCategory {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String createdAt;

  @HiveField(3)
  late String updatedAt;

  FoodCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: json['id'].toString(),
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}