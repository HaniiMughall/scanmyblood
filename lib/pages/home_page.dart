import 'package:flutter/material.dart';
import 'compatibility_page.dart';
import 'find_donor_page.dart';
import 'emergency_request_page.dart';
import 'donate_flow/verify_donation_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showBloodGroupDialog(BuildContext context) {
    String selectedGroup = 'A-';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Select Your Blood Group',
            style: TextStyle(
              color: Colors.red.shade900, // ✅ Darker for readability
              fontWeight: FontWeight.bold,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selectedGroup,
                items: ['A-', 'B-', 'AB+', 'O+', 'O-']
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.red.shade900,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          CompatibilityPage(myGroup: selectedGroup)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.all(6),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade900,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to Scan Blood App",
                  style: TextStyle(
                    color: Colors.red.shade900,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildMenuButton(
                        context,
                        "I want to Donate",
                        Icons.volunteer_activism,
                        () => _showBloodGroupDialog(context)),
                    _buildMenuButton(context, "I need Blood", Icons.bloodtype,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindDonorPage()),
                      );
                    }),
                  ],
                ),
                Row(
                  children: [
                    _buildMenuButton(
                        context, "Emergency Request", Icons.local_hospital, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmergencyRequestPage()),
                      );
                    }),
                    _buildMenuButton(context, "Mark as Donated", Icons.verified,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VerifyDonationPage()),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
