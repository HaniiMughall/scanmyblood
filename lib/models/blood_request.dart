import 'package:hive/hive.dart';
part 'blood_request.g.dart';

@HiveType(typeId: 2)
class BloodRequest extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String requesterName;

  @HiveField(2)
  String bloodGroup;

  @HiveField(3)
  String city;

  @HiveField(4)
  String? contact;

  @HiveField(5)
  RequestStatus status;

  BloodRequest({
    required this.id,
    required this.requesterName,
    required this.bloodGroup,
    required this.city,
    this.contact,
    this.status = RequestStatus.pending,
  });

  /// ✅ Convert to Map (for database or API)
  Map<String, dynamic> toJson() => {
        "id": id,
        "requesterName": requesterName,
        "bloodGroup": bloodGroup,
        "city": city,
        "contact": contact,
        "status": status.name, // enum ko string me save karenge
      };

  /// ✅ Convert back from Map
  factory BloodRequest.fromJson(Map<String, dynamic> json) => BloodRequest(
        id: json["id"],
        requesterName: json["requesterName"],
        bloodGroup: json["bloodGroup"],
        city: json["city"],
        contact: json["contact"],
        status: RequestStatus.values.firstWhere(
          (e) => e.name == json["status"],
          orElse: () => RequestStatus.pending,
        ),
      );
}

@HiveType(typeId: 3)
enum RequestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  approved,
  @HiveField(2)
  rejected,
}
