class LeaderboardEntry {
  final String userId;
  final String displayName;
  final int points;

  LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.points,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['userId'] ?? '',
      displayName: json['displayName'] ?? '',
      points: json['points'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'points': points,
    };
  }
}