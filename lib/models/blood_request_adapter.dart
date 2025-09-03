import 'package:hive/hive.dart';
import 'blood_request.dart';

class BloodRequestAdapter extends TypeAdapter<BloodRequest> {
  @override
  final int typeId = 2;
  @override
  BloodRequest read(BinaryReader reader) {
    final id = reader.readString();
    final requesterName = reader.readString();
    final bloodGroup = reader.readString();
    final city = reader.readString();
    final contact = reader.read() as String?;
    final status = RequestStatus.values[reader.readInt()];
    return BloodRequest(
      requesterName: requesterName,
      bloodGroup: bloodGroup,
      city: city,
      contact: contact,
      status: status,
      id: id,
    );
  }

  @override
  void write(BinaryWriter writer, BloodRequest obj) {
    writer.writeString(obj.requesterName);
    writer.writeString(obj.bloodGroup);
    writer.writeString(obj.city);
    writer.write(obj.contact);
    writer.writeInt(obj.status.index);
  }
}
