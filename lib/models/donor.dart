import 'package:hive/hive.dart';
part 'donor.g.dart';

@HiveType(typeId: 1)
class Donor extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String bloodGroup;

  @HiveField(3)
  String city;

  @HiveField(4)
  String contact;

  @HiveField(5)
  double? latitude;

  @HiveField(6)
  double? longitude;

  @HiveField(7)
  bool verified;

  @HiveField(8)
  int points; // ✅ Gamification

  @HiveField(9)
  String badge; // ✅ Gamification

  Donor({
    required this.id,
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

  /// ✅ Convert to Map
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "bloodGroup": bloodGroup,
        "city": city,
        "contact": contact,
        "latitude": latitude,
        "longitude": longitude,
        "verified": verified,
        "points": points,
        "badge": badge,
      };

  /// ✅ Convert back from Map
  factory Donor.fromJson(Map<String, dynamic> json) => Donor(
        id: json["id"],
        name: json["name"],
        bloodGroup: json["bloodGroup"],
        city: json["city"] ?? "",
        contact: json["contact"],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        verified: json["verified"] ?? false,
        points: json["points"] ?? 0,
        badge: json["badge"] ?? "",
      );
}
