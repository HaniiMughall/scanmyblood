import 'package:flutter/material.dart';
import '/utils/global_data.dart';
import '/models/donor.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation History"),
        backgroundColor: Colors.red.shade800,
        foregroundColor: Colors.white,
      ),
      body: donors.isEmpty
          ? const Center(
              child: Text("No donation history yet",
                  style: TextStyle(fontSize: 16)))
          : ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final Donor donor = donors[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(
                        donor.bloodGroup,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(donor.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${donor.city} • ${donor.contact}"),
                        Text("Points: ${donor.points}"),
                        Text("Badge: ${donor.badge}"),
                      ],
                    ),
                    trailing: donor.verified
                        ? const Icon(Icons.verified,
                            color: Colors.green, size: 28)
                        : const Icon(Icons.hourglass_empty,
                            color: Colors.orange, size: 28),
                  ),
                );
              },
            ),
    );
  }
}
