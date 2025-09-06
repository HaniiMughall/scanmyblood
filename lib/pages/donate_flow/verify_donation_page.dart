// verify_donation_page.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '/gamification/providers/gamification_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '/utils/global_data.dart';
import '/models/donor.dart';
import 'dart:ui';

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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("🎉 Congratulations!"),
        content: const Text(
            "You have completed your first donation!\n\n+50 Points Earned\n🏅 Badge Unlocked"),
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
    if (_formKey.currentState!.validate() && otpVerified) {
      final newDonor = Donor(
        id: Uuid().v4(),
        name: _nameController.text.trim(),
        bloodGroup: _bloodGroupController.text.trim(),
        city: _cityController.text.trim(),
        contact: _contactController.text.trim(),
        verified: false,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text("Verify Donation"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.red, Colors.black87])))),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black87, Colors.red])),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _glassField(
                            controller: _nameController,
                            label: "Full Name",
                            validatorMsg: "Enter your name"),
                        const SizedBox(height: 12),
                        _glassField(
                            controller: _bloodGroupController,
                            label: "Blood Group",
                            validatorMsg: "Enter blood group"),
                        const SizedBox(height: 12),
                        _glassField(
                            controller: _cityController,
                            label: "City",
                            validatorMsg: "Enter city"),
                        const SizedBox(height: 12),
                        _glassField(
                            controller: _contactController,
                            label: "Contact Number",
                            validatorMsg: "Enter contact"),
                        const SizedBox(height: 12),
                        _proofImage == null
                            ? TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image,
                                    color: Colors.white),
                                label: const Text(
                                    "Upload Proof Image (Optional)",
                                    style: TextStyle(color: Colors.white)),
                              )
                            : Image.file(_proofImage!, height: 150),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _glassField(
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
                          onPressed: _confirmDonation,
                          icon: const Icon(Icons.check_circle),
                          label: const Text("Yes, I Donated"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
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
        ),
      ),
    );
  }

  Widget _glassField(
      {required TextEditingController controller,
      required String label,
      required String validatorMsg}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      validator: (v) => validatorMsg.isEmpty
          ? null
          : (v == null || v.trim().isEmpty ? validatorMsg : null),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
