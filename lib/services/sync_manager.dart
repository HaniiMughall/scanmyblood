import 'package:connectivity_plus/connectivity_plus.dart';
import 'database_service.dart';
import 'api_service.dart';

class SyncManager {
  static Future<void> trySyncPending() async {
    final conn = await Connectivity().checkConnectivity();
    if (conn == ConnectivityResult.none) return;
    final pending = await DatabaseService.instance.getPending();
    for (int i=0;i<pending.length;i++) {
      final item = Map<String,dynamic>.from(pending[i]);
      final type = item['type'] ?? '';
      final data = Map<String,dynamic>.from(item['data'] ?? {});
      bool ok = false;
      if (type == 'donor') ok = await ApiService.uploadDonor(data);
      if (type == 'request') ok = await ApiService.uploadRequest(data);
      if (ok) {
        await DatabaseService.instance.clearPendingAt(0);
        return trySyncPending();
      }
    }
  }
}
