// FavoriteModel.dart
import 'package:hive/hive.dart';

part 'FavoriteModel.g.dart';

@HiveType(typeId: 3)
class FavoriteItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final int foodId; // Change to int
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String price;
  
  @HiveField(5)
  final String image;
  
  @HiveField(6)
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.foodId, // Now int
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.addedAt,
  });
}