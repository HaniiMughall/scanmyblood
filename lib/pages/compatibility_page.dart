import 'package:flutter/material.dart';
import 'donate_flow/donor_form_page.dart';
import 'package:scanmyblood/widgets/theme_page.dart';

class CompatibilityPage extends StatelessWidget {
  final String myGroup;

  const CompatibilityPage({required this.myGroup, super.key});

  final Map<String, List<String>> compatibilityMap = const {
    "A+": ["A+", "AB+"],
    "A-": ["A+", "A-", "AB+", "AB-"],
    "B+": ["B+", "AB+"],
    "B-": ["B+", "B-", "AB+", "AB-"],
    "AB+": ["AB+"],
    "AB-": ["AB+", "AB-"],
    "O+": ["A+", "B+", "AB+", "O+"],
    "O-": ["A+", "B+", "AB+", "O+", "A-", "B-", "AB-", "O-"],
  };

  @override
  Widget build(BuildContext context) {
    final canDonateTo = compatibilityMap[myGroup] ?? [];

    return ThemedPage(
      title: "Donation Compatibility",
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: canDonateTo.length,
              itemBuilder: (context, index) {
                String g = canDonateTo[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text("You can donate to $g"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade900,
                        foregroundColor: Colors.white, // ✅ text white hoga
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonorFormPage(myGroup: myGroup),
                          ),
                        );
                      },
                      child: const Text("Donate Now"),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
