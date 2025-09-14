import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/gamification/providers/gamification_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/utils/global_data.dart';
import '/models/donor.dart';

class VerifyDonationPage extends StatefulWidget {
  const VerifyDonationPage({super.key});

  @override
  State<VerifyDonationPage> createState() => _VerifyDonationPageState();
}

class _VerifyDonationPageState extends State<VerifyDonationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _cityController = TextEditingController();
  final _contactController = TextEditingController();
  final _otpController = TextEditingController();

  File? _proofImage;
  bool otpVerified = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _proofImage = File(picked.path));
    }
  }

  void _verifyOtp() {
    if (_otpController.text.trim() == "1234") {
      setState(() => otpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ OTP Verified")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Invalid OTP")),
      );
    }
  }

  void _confirmDonation() {
    final provider = Provider.of<GamificationProvider>(context, listen: false);
    provider.awardDonationBadge(
      userId: "u1",
      displayName: _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : "Anonymous Donor",
    );

    if (_formKey.currentState!.validate() && otpVerified) {
      final newDonor = Donor(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        bloodGroup: _bloodGroupController.text.trim(),
        city: _cityController.text.trim(),
        contact: _contactController.text.trim(),
        verified: true,
        points: 50,
        badge: "🏅 Bronze Donor",
      );

      donors.add(newDonor);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("🎉 Congratulations!"),
          content: const Text(
              "You have completed your donation!\n\n+50 Points Earned\n🏅 Badge Unlocked"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠️ Please complete all fields & verify OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify Donation",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red.shade900,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                        controller: _nameController,
                        label: "Full Name",
                        validatorMsg: "Enter your name"),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: null,
                      decoration: InputDecoration(
                        labelText: "Blood Group",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                          .map((bg) => DropdownMenuItem(
                                value: bg,
                                child: Text(bg),
                              ))
                          .toList(),
                      onChanged: (val) {
                        _bloodGroupController.text = val ?? "";
                      },
                      validator: (val) => val == null || val.isEmpty
                          ? "Select blood group"
                          : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                        controller: _cityController,
                        label: "City",
                        validatorMsg: "Enter city"),
                    const SizedBox(height: 12),
                    _buildField(
                        controller: _contactController,
                        label: "Contact Number",
                        validatorMsg: "Enter contact"),
                    const SizedBox(height: 12),
                    _proofImage == null
                        ? TextButton.icon(
                            onPressed: _pickImage,
                            icon:
                                const Icon(Icons.image, color: Colors.black87),
                            label: const Text("Upload Proof Image (Optional)",
                                style: TextStyle(color: Colors.black87)),
                          )
                        : Image.file(_proofImage!, height: 150),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                              controller: _otpController,
                              label: "Enter OTP",
                              validatorMsg: ""),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: const Text("Verify"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: otpVerified ? _confirmDonation : null,
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Yes, I Donated"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: otpVerified
                            ? Colors.red.shade900
                            : Colors.grey, // grey if disabled
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      {required TextEditingController controller,
      required String label,
      required String validatorMsg}) {
    return TextFormField(
      controller: controller,
      validator: (v) => validatorMsg.isEmpty
          ? null
          : (v == null || v.trim().isEmpty ? validatorMsg : null),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
