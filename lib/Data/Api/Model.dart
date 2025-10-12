import 'package:hive/hive.dart';

part 'Model.g.dart'; // This will be generated

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

  Data({
    required this.itemId,
    required this.sloat,
    required this.name,
    required this.description,
    required this.price,
    required this.img,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      itemId: json['item_id'],
      sloat: json['sloat'],
      name: json['name'],
      description: json['Description'],
      price: json['price'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() => {
        'item_id': itemId,
        'sloat': sloat,
        'name': name,
        'Description': description,
        'price': price,
        'img': img,
      };
}
