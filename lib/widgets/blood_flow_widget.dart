import 'package:flutter/material.dart';

class BloodFlowWidget extends StatelessWidget {
  final String donorGroup;
  final List<String> canDonateTo;

  const BloodFlowWidget({
    super.key,
    required this.donorGroup,
    required this.canDonateTo,
  });

  Widget _personPill(String group, bool highlighted) {
    return Column(
      children: [
        Icon(
          Icons.person,
          size: 36,
          color: highlighted ? Colors.red : Colors.grey.shade400,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: highlighted ? Colors.red.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            group,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: highlighted ? Colors.red : Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // split two columns for aesthetics
    final left = <Widget>[];
    final right = <Widget>[];

    for (var i = 0; i < canDonateTo.length; i++) {
      final w = _personPill(canDonateTo[i], true);
      if (i.isEven)
        left.add(w);
      else
        right.add(w);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                // Blood bag
                Column(
                  children: [
                    Icon(Icons.bloodtype, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      "Your group",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      donorGroup,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Flow area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Can donate to:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: left),
                          Column(children: right),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              "Tap 'Fill Donor Form' to add yourself to the public donor list.",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
