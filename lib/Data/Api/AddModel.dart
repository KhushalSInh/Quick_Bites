import 'package:hive/hive.dart';

part 'AddModel.g.dart';

@HiveType(typeId: 1)
class UserAdd extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String userId;

  @HiveField(2)
  late String type;

  @HiveField(3)
  late String name;

  @HiveField(4)
  late String pincode;

  @HiveField(5)
  late String state;

  @HiveField(6)
  late String district;

  @HiveField(7)
  late String city;

  @HiveField(8)
  late String al1;

  @HiveField(9)
  late String al2;

  @HiveField(10)
  late String createdAt;

  @HiveField(11)
  late String isDefault;

  UserAdd({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.pincode,
    required this.state,
    required this.district,
    required this.city,
    required this.al1,
    required this.al2,
    required this.createdAt,
    required this.isDefault,
  });

  factory UserAdd.fromJson(Map<String, dynamic> json) {
    return UserAdd(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      pincode: json['pincode'] ?? '',
      state: json['state'] ?? '',
      district: json['district'] ?? '',
      city: json['city'] ?? '',
      al1: json['al1'] ?? '',
      al2: json['al2'] ?? '',
      createdAt: json['created_at'] ?? '',
      isDefault: json['is_default'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'name': name,
      'pincode': pincode,
      'state': state,
      'district': district,
      'city': city,
      'al1': al1,
      'al2': al2,
      'created_at': createdAt,
      'is_default': isDefault,
    };
  }
}
