import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/donor.dart';
import '../models/blood_request.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static const String usersBox = "users";
  static const String donorsBox = "donors";
  static const String requestsBox = "requests";
  static const String pendingBox = "pending";

  /// ✅ Init Hive
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DonorAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BloodRequestAdapter());
    }

    if (!Hive.isBoxOpen(usersBox)) await Hive.openBox<User>(usersBox);
    if (!Hive.isBoxOpen(donorsBox)) await Hive.openBox<Donor>(donorsBox);
    if (!Hive.isBoxOpen(requestsBox))
      await Hive.openBox<BloodRequest>(requestsBox);
    if (!Hive.isBoxOpen(pendingBox)) await Hive.openBox<dynamic>(pendingBox);
  }

  /// ✅ Add user
  Future<void> addUser(User user) async {
    final box = Hive.box<User>(usersBox);
    await box.put(user.email, user);
  }

  /// ✅ Get user (async banaya)
  Future<User?> getUser(String email) async {
    final box = Hive.box<User>(usersBox);
    return box.get(email);
  }

  /// ✅ Validate login
  Future<bool> validateUser(String email, String password) async {
    final box = Hive.box<User>(usersBox);
    final user = box.get(email);
    if (user == null) return false;
    return user.password == password;
  }

  /// ✅ Get all users
  Future<List<User>> getAllUsers() async {
    final box = Hive.box<User>(usersBox);
    return box.values.toList();
  }

  /// ✅ Add donor
  Future<void> addDonor(Donor donor, {bool pendingSync = false}) async {
    final box = Hive.box<Donor>(donorsBox);
    await box.put(donor.id, donor);

    if (pendingSync) {
      final pBox = Hive.box<dynamic>(pendingBox);
      await pBox.add({"type": "donor", "data": donor.toJson()});
    }
  }

  /// ✅ Get all donors
  Future<List<Donor>> getAllDonors() async {
    final box = Hive.box<Donor>(donorsBox);
    return box.values.toList();
  }

  /// ✅ Add request
  Future<void> addBloodRequest(BloodRequest request,
      {bool pendingSync = false}) async {
    final box = Hive.box<BloodRequest>(requestsBox);
    await box.put(request.id, request);

    if (pendingSync) {
      final pBox = Hive.box<dynamic>(pendingBox);
      await pBox.add({"type": "request", "data": request.toJson()});
    }
  }

  /// ✅ Alias (for backward compatibility)
  Future<void> addRequest(BloodRequest request, {bool pendingSync = false}) {
    return addBloodRequest(request, pendingSync: pendingSync);
  }

  /// ✅ Pending sync support
  Future<List<dynamic>> getPending() async {
    final box = Hive.box<dynamic>(pendingBox);
    return box.values.toList();
  }

  Future<void> clearPendingAt(int index) async {
    final box = Hive.box<dynamic>(pendingBox);
    await box.deleteAt(index);
  }
}
