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
    required this.requesterName,
    required this.bloodGroup,
    required this.city,
    this.contact,
    this.status = RequestStatus.pending,
    required this.id,
  });
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
