import 'package:hive/hive.dart';
part 'donor.g.dart';

@HiveType(typeId: 1)
class Donor extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String bloodGroup;

  @HiveField(2)
  String city;

  @HiveField(3)
  String contact;

  @HiveField(4)
  double? latitude;

  @HiveField(5)
  double? longitude;

  @HiveField(6)
  bool verified;

  @HiveField(7)
  int points; // ✅ New field

  @HiveField(8)
  String badge; // ✅ New field

  Donor({
    required this.name,
    required this.bloodGroup,
    required this.city,
    required this.contact,
    this.latitude,
    this.longitude,
    this.verified = false,
    this.points = 0,
    this.badge = "",
  });
}
