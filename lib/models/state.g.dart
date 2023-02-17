// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StateModelAdapter extends TypeAdapter<StateModel> {
  @override
  final int typeId = 1;

  @override
  StateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StateModel(
      name: fields[0] as String,
      stateId: fields[1] as int,
      zoneId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StateModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.stateId)
      ..writeByte(2)
      ..write(obj.zoneId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
