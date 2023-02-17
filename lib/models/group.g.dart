// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupAdapter extends TypeAdapter<Group> {
  @override
  final int typeId = 5;

  @override
  Group read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Group(
      cname: fields[2] as String,
      demand: (fields[8] as List).cast<String>(),
      lga: fields[6] as int,
      name: fields[0] as String,
      phone: fields[1] as String,
      secretary: fields[3] as String,
      state: fields[5] as int,
      ward: fields[7] as int,
      zone: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.cname)
      ..writeByte(3)
      ..write(obj.secretary)
      ..writeByte(4)
      ..write(obj.zone)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.lga)
      ..writeByte(7)
      ..write(obj.ward)
      ..writeByte(8)
      ..write(obj.demand);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
