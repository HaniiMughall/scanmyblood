import 'package:flutter/material.dart';
import 'compatibility_page.dart';
import 'find_donor_page.dart';
import 'emergency_request_page.dart';
import 'donate_flow/verify_donation_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleLanguage;
  final bool isDarkMode;
  final bool isEnglish;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.toggleLanguage,
    required this.isDarkMode,
    required this.isEnglish,
  });

  Widget _buildGlassButton(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      height: 100,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.15),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
        ),
        icon: Icon(icon, size: 28, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.1,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }

  void _showBloodGroupDialog(BuildContext context) {
    String selectedGroup = 'A+';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.85),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Select Your Blood Group',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                dropdownColor: Colors.black,
                isExpanded: true,
                value: selectedGroup,
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((group) => DropdownMenuItem(
                          value: group,
                          child: Text(group,
                              style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedGroup = value;
                    });
                  }
                },
              );
            },
          ),
          actions: [
            TextButton(
              child:
                  const Text('Next', style: TextStyle(color: Colors.redAccent)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildGlassButton(
                        context,
                        "I want to Donate",
                        Icons.volunteer_activism,
                        () => _showBloodGroupDialog(context)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGlassButton(
                        context, "I need Blood", Icons.bloodtype, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FindDonorPage()),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildGlassButton(
                        context, "Emergency Request", Icons.local_hospital, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmergencyRequestPage()),
                      );
                    }),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildGlassButton(
                        context, "Mark as Donated", Icons.verified, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const VerifyDonationPage()),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
