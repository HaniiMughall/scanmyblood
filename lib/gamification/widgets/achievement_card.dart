import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../providers/gamification_provider.dart';

class AchievementCard extends StatelessWidget {
  final Achievement ach;
  const AchievementCard({super.key, required this.ach});

  @override
  Widget build(BuildContext context) {
    final has = context.select((GamificationProvider p) => p.hasAchievement(ach.id));
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(child: Icon(has ? Icons.verified : Icons.lock)),
        title: Text(ach.title),
        subtitle: Text(ach.description),
        trailing: has ? Text('+${ach.pointsReward}') : Text('Locked'),
      ),
    );
  }
}
