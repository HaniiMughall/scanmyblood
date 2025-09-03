class Achievement {
  final String id;
  final String title;
  final String description;
  final int pointsReward;
  final bool oneTime; // true for one-time achievements
  final int target; // e.g., number of donations for "Donate 3 times"

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsReward,
    this.oneTime = true,
    this.target = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'pointsReward': pointsReward,
        'oneTime': oneTime,
        'target': target,
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        pointsReward: json['pointsReward'],
        oneTime: json['oneTime'] ?? true,
        target: json['target'] ?? 1,
      );
}
