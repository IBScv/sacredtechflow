// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synchronicity_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SynchronicityEntryAdapter extends TypeAdapter<SynchronicityEntry> {
  @override
  final int typeId = 0;

  @override
  SynchronicityEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SynchronicityEntry(
      date: fields[0] as DateTime,
      type: fields[1] as String,
      observation: fields[2] as String,
      feeling: fields[3] as String,
      action: fields[4] as String?,
      intensity: fields[5] as int,
      isPrimary: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SynchronicityEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.observation)
      ..writeByte(3)
      ..write(obj.feeling)
      ..writeByte(4)
      ..write(obj.action)
      ..writeByte(5)
      ..write(obj.intensity)
      ..writeByte(6)
      ..write(obj.isPrimary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynchronicityEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
