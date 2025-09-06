import 'package:flutter/material.dart';
import 'donate_flow/donor_form_page.dart';
import 'compatibility_page.dart';
import 'find_donor_page.dart';
import 'emergency_request_page.dart';
import 'donate_flow/verify_donation_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildGlassButton(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return SizedBox(
      height: 100, // Fixed height for uniform buttons
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.9),
          foregroundColor: const Color(0xFF8B0000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 5,
        ),
        icon: Icon(icon, size: 30),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
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
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Select Your Blood Group',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selectedGroup,
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
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
              child: const Text('Next', style: TextStyle(color: Colors.red)),
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
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // First row
              Row(
                children: [
                  Expanded(
                    child: _buildGlassButton(
                        context,
                        "I want to Donate",
                        Icons.volunteer_activism,
                        () => _showBloodGroupDialog(context)),
                  ),
                  const SizedBox(width: 20),
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
              // Second row
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
                  const SizedBox(width: 20),
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
