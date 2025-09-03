// lib/services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _lastCityKey = 'last_city';

  static Future<void> setLastCity(String city) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_lastCityKey, city);
  }

  static Future<String?> getLastCity() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_lastCityKey);
  }
}
