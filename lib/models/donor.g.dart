// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DonorAdapter extends TypeAdapter<Donor> {
  @override
  final int typeId = 1;

  @override
  Donor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Donor(
      id: fields[0] as String,
      name: fields[1] as String,
      bloodGroup: fields[2] as String,
      city: fields[3] as String,
      contact: fields[4] as String,
      latitude: fields[5] as double?,
      longitude: fields[6] as double?,
      verified: fields[7] as bool,
      points: fields[8] as int,
      badge: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Donor obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bloodGroup)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.contact)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude)
      ..writeByte(7)
      ..write(obj.verified)
      ..writeByte(8)
      ..write(obj.points)
      ..writeByte(9)
      ..write(obj.badge);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
