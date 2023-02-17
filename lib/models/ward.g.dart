// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ward.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WardModelAdapter extends TypeAdapter<WardModel> {
  @override
  final int typeId = 3;

  @override
  WardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WardModel(
      name: fields[0] as String,
      wardId: fields[1] as int,
      lgaId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WardModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.wardId)
      ..writeByte(2)
      ..write(obj.lgaId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
