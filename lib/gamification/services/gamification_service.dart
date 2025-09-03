import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leaderboard_entry.dart';

class GamificationService {
  static const _kPointsKey = 'gf_points';
  static const _kAchievementsEarnedKey = 'gf_achievements';
  static const _kLeaderboardKey = 'gf_leaderboard';
  static const _kStreakKey = 'gf_streak';

  Future<int> loadPoints() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kPointsKey) ?? 0;
  }

  Future<void> savePoints(int points) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kPointsKey, points);
  }

  Future<List<String>> loadEarnedAchievementIds() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kAchievementsEarnedKey) ?? [];
  }

  Future<void> saveEarnedAchievementIds(List<String> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kAchievementsEarnedKey, ids);
  }

  Future<List<LeaderboardEntry>> loadLeaderboard() async {
    final sp = await SharedPreferences.getInstance();
    final jsonStr = sp.getString(_kLeaderboardKey);
    if (jsonStr == null) return [];
    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveLeaderboard(List<LeaderboardEntry> entries) async {
    final sp = await SharedPreferences.getInstance();
    final jsonStr =
        json.encode(entries.map((e) => e.toJson()).toList());
    await sp.setString(_kLeaderboardKey, jsonStr);
  }

  Future<int> loadStreak() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kStreakKey) ?? 0;
  }

  Future<void> saveStreak(int streak) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kStreakKey, streak);
  }
}
