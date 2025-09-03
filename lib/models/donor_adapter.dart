import 'package:hive/hive.dart';
import 'donor.dart';

class DonorAdapter extends TypeAdapter<Donor> {
  @override
  final int typeId = 1;

  @override
  Donor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Donor(
      name: fields[0] as String,
      bloodGroup: fields[1] as String,
      city: fields[2] as String,
      contact: fields[3] as String,
      latitude: fields[4] as double?,
      longitude: fields[5] as double?,
      verified: fields[6] as bool,
      points: fields[7] as int,
      badge: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Donor obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.bloodGroup)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.contact)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.verified)
      ..writeByte(7)
      ..write(obj.points)
      ..writeByte(8)
      ..write(obj.badge);
  }
}
