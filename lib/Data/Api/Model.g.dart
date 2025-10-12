// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 0;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      itemId: fields[0] as String,
      sloat: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      price: fields[4] as String,
      img: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.sloat)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.img);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

 // This will be generated

@HiveType(typeId: 1) // Use a unique typeId
class User extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String pincode;

  @HiveField(3)
  late String state;

  @HiveField(4)
  late String district;

  @HiveField(5)
  late String city;

  @HiveField(6)
  late String al1;

  @HiveField(7)
  late String al2;

  User({
    required this.userId,
    required this.name,
    required this.pincode,
    required this.state,
    required this.district,
    required this.city,
    required this.al1,
    required this.al2,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'],
        name: json['name'],
        pincode: json['pincode'],
        state: json['state'],
        district: json['district'],
        city: json['city'],
        al1: json['al1'],
        al2: json['al2'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'name': name,
        'pincode': pincode,
        'state': state,
        'district': district,
        'city': city,
        'al1': al1,
        'al2': al2,
      };
}
