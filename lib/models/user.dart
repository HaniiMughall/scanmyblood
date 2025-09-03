import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(1)
  final String id;

  @HiveField(2)
  String name;

  @HiveField(3)
  String email;

  @HiveField(4)
  String password;

  @HiveField(5)
  String? bloodGroup;

  @HiveField(6)
  String? contact;

  @HiveField(7)
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
