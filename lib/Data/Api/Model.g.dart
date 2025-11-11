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
      categoryId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.img)
      ..writeByte(6)
      ..write(obj.categoryId);
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
