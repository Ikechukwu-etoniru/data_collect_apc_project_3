// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lg.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LgModelAdapter extends TypeAdapter<LgModel> {
  @override
  final int typeId = 2;

  @override
  LgModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LgModel(
      name: fields[0] as String,
      lgaId: fields[1] as int,
      stateId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LgModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.lgaId)
      ..writeByte(2)
      ..write(obj.stateId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LgModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
