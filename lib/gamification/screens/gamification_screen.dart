import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../widgets/achievement_card.dart';
import '../widgets/points_badge_widget.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GamificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards & Achievements'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top summary
            Row(
              children: [
                const PointsBadgeWidget(size: 64),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Points: ${provider.points}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Streak: ${provider.streak} days'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),

            // Achievements
            Text(
              'Achievements',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...provider.achievements
                .map((a) => AchievementCard(ach: a))
                .toList(),

            const SizedBox(height: 16),

            // Leaderboard
            Text(
              'Leaderboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...provider.leaderboard.map(
              (e) => ListTile(
                leading: CircleAvatar(
                  child: Text(
                      e.displayName.isNotEmpty ? e.displayName[0] : '?'),
                ),
                title: Text(e.displayName),
                trailing: Text('${e.points} pts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}