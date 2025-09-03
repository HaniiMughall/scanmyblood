import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/donor.dart';
import '../models/blood_request.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static const String usersBox = 'users_box';
  static const String donorsBox = 'donors_box';
  static const String requestsBox = 'requests_box';
  static const String pendingBox = 'pending_box';

  Future<void> init() async {
    if (!Hive.isBoxOpen(usersBox)) await Hive.openBox<User>(usersBox);
    if (!Hive.isBoxOpen(donorsBox)) await Hive.openBox<Donor>(donorsBox);
    if (!Hive.isBoxOpen(requestsBox))
      await Hive.openBox<BloodRequest>(requestsBox);
    if (!Hive.isBoxOpen(pendingBox)) await Hive.openBox<dynamic>(pendingBox);
  }

  // -------------------- USERS --------------------
  Future<void> addUser(User user) async {
    final box = Hive.box<User>(usersBox);
    await box.put(user.email, user);
  }

  Future<bool> validateUser(String email, String password) async {
    final box = Hive.box<User>(usersBox);
    if (!box.containsKey(email)) return false;
    final u = box.get(email)!;
    return u.password == password;
  }

  Future<User?> getUser(String email) async {
    final box = Hive.box<User>(usersBox);
    return box.get(email);
  }

  // -------------------- DONORS --------------------
  Future<void> addDonor(Donor donor, {bool pendingSync = true}) async {
    final box = Hive.box<Donor>(donorsBox);

    Donor? existing;
    try {
      existing = box.values.firstWhere((d) => d.contact == donor.contact);
    } catch (e) {
      existing = null;
    }

    if (existing != null) {
      existing.name = donor.name;
      existing.city = donor.city;
      existing.bloodGroup = donor.bloodGroup;
      existing.verified = donor.verified;
      await existing.save();
    } else {
      await box.add(donor);
    }

    if (pendingSync && existing == null) {
      await addPending({
        'type': 'donor',
        'data': {
          'name': donor.name,
          'bloodGroup': donor.bloodGroup,
          'city': donor.city,
          'contact': donor.contact,
        },
      });
    }
  }

  Future<List<Donor>> getAllDonors() async {
    final box = Hive.box<Donor>(donorsBox);
    return box.values.toList();
  }

  Future<List<Donor>> searchDonors(String query) async {
    final lower = query.toLowerCase();
    final all = await getAllDonors();
    return all.where((d) {
      return d.name.toLowerCase().contains(lower) ||
          d.city.toLowerCase().contains(lower) ||
          d.bloodGroup.toLowerCase().contains(lower) ||
          d.contact.toLowerCase().contains(lower);
    }).toList();
  }

  // -------------------- BLOOD REQUESTS --------------------
  Future<void> addRequest(BloodRequest r, {bool pendingSync = true}) async {
    final box = Hive.box<BloodRequest>(requestsBox);
    await box.add(r);

    if (pendingSync) {
      await addPending({
        'type': 'request',
        'data': {
          'requesterName': r.requesterName,
          'bloodGroup': r.bloodGroup,
          'city': r.city,
          'contact': r.contact,
          'status': r.status.toString(),
        },
      });
    }
  }

  Future<List<BloodRequest>> getAllRequests() async {
    final box = Hive.box<BloodRequest>(requestsBox);
    return box.values.toList();
  }

  // -------------------- PENDING SYNC --------------------
  Future<void> addPending(Map<String, dynamic> item) async {
    final box = Hive.box<dynamic>(pendingBox);
    await box.add(item);
  }

  Future<List<dynamic>> getPending() async {
    final box = Hive.box<dynamic>(pendingBox);
    return box.values.toList();
  }

  Future<void> clearPendingAt(int index) async {
    final box = Hive.box<dynamic>(pendingBox);
    final key = box.keyAt(index);
    await box.delete(key);
  }
}
