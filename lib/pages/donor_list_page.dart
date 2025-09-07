import 'package:flutter/material.dart';
import 'package:scanmyblood/services/database_service.dart';
import 'package:scanmyblood/models/donor.dart';
import 'package:scanmyblood/widgets/theme_page.dart';

class DonorListPage extends StatelessWidget {
  const DonorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      title: "All Donors",
      child: FutureBuilder<List<Donor>>(
        future: DatabaseService.instance.getAllDonors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No donors found"));
          }

          final donors = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: donors.length,
            itemBuilder: (ctx, i) {
              final d = donors[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade100,
                    child: Text(
                      d.bloodGroup,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  title: Text(d.name),
                  subtitle: Text("${d.city} • ${d.contact}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Contacting ${d.name}...")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                    ),
                    child: const Text("Contact"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
