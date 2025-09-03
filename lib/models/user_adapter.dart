import 'package:hive/hive.dart';
import 'user.dart';

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;
  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return User(
      id: fields[1] as String,
      name: fields[2] as String,
      email: fields[3] as String,
      password: fields[4] as String,
      bloodGroup: fields[5] as String?,
      contact: fields[6] as String?,
      role: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.bloodGroup)
      ..writeByte(4)
      ..write(obj.contact);
  }
}
