import 'package:hive/hive.dart';

part 'Model.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject {
  @HiveField(0)
  late String itemId;

  @HiveField(1)
  late String sloat;

  @HiveField(2)
  late String name;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String price;

  @HiveField(5)
  late String img;

  @HiveField(6) // NEW FIELD - Add this
  late String categoryId; // Changed to String to match your database

  Data({
    required this.itemId,
    required this.sloat,
    required this.name,
    required this.description,
    required this.price,
    required this.img,
    required this.categoryId, // NEW - Add this
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      itemId: json['item_id'],
      sloat: json['sloat'],
      name: json['name'],
      description: json['Description'],
      price: json['price'],
      img: json['img'],
      categoryId: json['category_id'].toString(), // NEW - Convert to string
    );
  }

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'sloat': sloat,
        'name': name,
        'Description': description,
        'price': price,
        'img': img,
        'category_id': categoryId, // NEW - Add this
      };
}