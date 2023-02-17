// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IndividualAdapter extends TypeAdapter<Individual> {
  @override
  final int typeId = 4;

  @override
  Individual read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Individual(
      category: fields[10] as String,
      cphone: fields[2] as String,
      demand: (fields[12] as List).cast<String>(),
      lga: fields[5] as int,
      name: fields[0] as String,
      phone: fields[1] as String,
      pollingUnit: fields[11] as String,
      state: fields[4] as int,
      vlga: fields[8] as int,
      vstate: fields[7] as int,
      vward: fields[9] as int,
      ward: fields[6] as int,
      zone: fields[3] as int,
      vinNumber: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Individual obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.cphone)
      ..writeByte(3)
      ..write(obj.zone)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.lga)
      ..writeByte(6)
      ..write(obj.ward)
      ..writeByte(7)
      ..write(obj.vstate)
      ..writeByte(8)
      ..write(obj.vlga)
      ..writeByte(9)
      ..write(obj.vward)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.pollingUnit)
      ..writeByte(12)
      ..write(obj.demand)
      ..writeByte(13)
      ..write(obj.vinNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IndividualAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
