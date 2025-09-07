import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  @HiveField(4)
  String? bloodGroup;

  @HiveField(5)
  String? contact;

  @HiveField(6)
  final String role; // "user" ya "admin"

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.bloodGroup,
    this.contact,
    required this.role,
  });
}
