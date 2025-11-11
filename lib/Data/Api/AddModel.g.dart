// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAddAdapter extends TypeAdapter<UserAdd> {
  @override
  final int typeId = 4;

  @override
  UserAdd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAdd(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as String,
      name: fields[3] as String,
      pincode: fields[4] as String,
      state: fields[5] as String,
      district: fields[6] as String,
      city: fields[7] as String,
      al1: fields[8] as String,
      al2: fields[9] as String,
      createdAt: fields[10] as String,
      isDefault: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserAdd obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.pincode)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.district)
      ..writeByte(7)
      ..write(obj.city)
      ..writeByte(8)
      ..write(obj.al1)
      ..writeByte(9)
      ..write(obj.al2)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAddAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
