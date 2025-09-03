import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/achievement.dart';
import '../models/leaderboard_entry.dart';
import '../services/gamification_service.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _service;

  int _points = 0;
  int get points => _points;

  int _streak = 0;
  int get streak => _streak;

  final List<Achievement> achievementsDefinition;

  final Set<String> _earned = {};

  List<LeaderboardEntry> _leaderboard = [];

  GamificationProvider({
    required GamificationService service,
    required this.achievementsDefinition,
  }) : _service = service {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    _points = await _service.loadPoints();
    _streak = await _service.loadStreak();
    final earnedIds = await _service.loadEarnedAchievementIds();
    _earned.addAll(earnedIds);
    final lb = await _service.loadLeaderboard();
    _leaderboard.addAll(lb);
    notifyListeners();
  }

  Future<void> _saveAll() async {
    await _service.savePoints(_points);
    await _service.saveStreak(_streak);
    await _service.saveEarnedAchievementIds(_earned.toList());
    await _service.saveLeaderboard(_leaderboard);
  }

  void addPoints(int p, {String? reason}) {
    if (p <= 0) return;
    _points += p;
    notifyListeners();
    _saveAll();
  }

  void incrementStreak() {
    _streak += 1;
    notifyListeners();
    _saveAll();
  }

  bool hasAchievement(String id) => _earned.contains(id);

  /// Check and award achievements (call this after user actions)
  void checkAndAwardAchievements({
    required String userId,
    required String displayName,
    required Map<String, int> counters,
  }) {
    for (final a in achievementsDefinition) {
      if (_earned.contains(a.id) && a.oneTime) continue;

      final count = counters[a.id] ?? 0;

      if (a.oneTime) {
        if (count >= a.target) {
          _earned.add(a.id);
          addPoints(a.pointsReward, reason: 'Achievement: ${a.title}');
        }
      } else {
        if (count > 0 && count % a.target == 0) {
          addPoints(a.pointsReward, reason: 'Milestone: ${a.title}');
        }
      }
    }

    _updateLocalLeaderboard(userId: userId, displayName: displayName);
    _saveAll();
  }

  void _updateLocalLeaderboard({
    required String userId,
    required String displayName,
  }) {
    final idx = _leaderboard.indexWhere((e) => e.userId == userId);
    if (idx >= 0) {
      _leaderboard[idx] = LeaderboardEntry(
        userId: userId,
        displayName: displayName,
        points: _points,
      );
    } else {
      _leaderboard.add(
        LeaderboardEntry(
          userId: userId,
          displayName: displayName,
          points: _points,
        ),
      );
    }
    _leaderboard.sort((a, b) => b.points.compareTo(a.points));
    notifyListeners();
  }

  UnmodifiableListView<LeaderboardEntry> get leaderboard =>
      UnmodifiableListView(_leaderboard);
  UnmodifiableListView<Achievement> get achievements =>
      UnmodifiableListView(achievementsDefinition);
  UnmodifiableListView<String> get earnedAchievements =>
      UnmodifiableListView(_earned.toList());

  // ✅ Getter for unlocked badges
  List<String> get badges =>
      _earned.map((id) {
        final a = achievementsDefinition.firstWhere(
          (ach) => ach.id == id,
          orElse: () => Achievement(
            id: id,
            title: id,
            description: "",
            pointsReward: 0,
            target: 0,
            oneTime: true,
          ),
        );
        return a.title;
      }).toList();

  // 🔥 OTP Verified → Award Donation Badge
  void awardDonationBadge({
    required String userId,
    required String displayName,
  }) {
    // Fixed points for verified donation
    addPoints(50, reason: "Verified Donation");

    // Award "first_donation" achievement if not earned
    if (!_earned.contains("first_donation")) {
      _earned.add("first_donation");
      addPoints(100, reason: "Achievement: First Donation");
    }

    // Update leaderboard
    _updateLocalLeaderboard(userId: userId, displayName: displayName);
    _saveAll();
  }
}
