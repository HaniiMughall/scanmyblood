import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import 'package:badges/badges.dart' as badges;

class PointsBadgeWidget extends StatelessWidget {
  const PointsBadgeWidget({super.key, this.size = 44.0});
  final double size;

  @override
  Widget build(BuildContext context) {
    final points = context.select((GamificationProvider p) => p.points);
    return badges.Badge(
      badgeContent: Text(points.toString(), style: TextStyle(color: Colors.white, fontSize: 12)),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        ),
        child: Center(child: Icon(Icons.local_offer_outlined)),
      ),
    );
  }
}
