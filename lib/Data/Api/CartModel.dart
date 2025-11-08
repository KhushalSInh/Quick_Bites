// ignore_for_file: non_constant_identifier_names

import 'package:hive/hive.dart';

part 'CartModel.g.dart';

@HiveType(typeId: 2)
class CartItem {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String foodId;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final String price;
  
  @HiveField(5)
  final String image;
  
  @HiveField(6)
  int quantity;
  
  @HiveField(7)
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.foodId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.quantity,
    required this.addedAt,
  });

  int get totalPrice => int.parse(price) * quantity;

  CartItem copyWith({
    int? quantity,
  }) {
    return CartItem(
      id: id,
      foodId: foodId,
      name: name,
      description: description,
      price: price,
      image: image,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt,
    );
  }
}