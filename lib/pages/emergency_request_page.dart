// emergency_request_page.dart
import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/blood_request.dart';
import '../../services/database_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui';

class EmergencyRequestPage extends StatefulWidget {
  const EmergencyRequestPage({super.key});

  @override
  State<EmergencyRequestPage> createState() => _EmergencyRequestPageState();
}

class _EmergencyRequestPageState extends State<EmergencyRequestPage> {
  final _city = TextEditingController();
  final _group = TextEditingController();
  final _contact = TextEditingController();
  bool _notificationsEnabled = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
    NotificationService.instance.init();
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _submitRequest() async {
    if (_city.text.trim().isEmpty || _group.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter city & blood group")));
      return;
    }

    setState(() => _submitting = true);

    final request = BloodRequest(
      id: const Uuid().v4(),
      requesterName: 'Anonymous',
      city: _city.text.trim(),
      bloodGroup: _group.text.trim().toUpperCase(),
      contact: _contact.text.trim(),
      status: RequestStatus.pending,
    );

    await DatabaseService.instance.addRequest(request);

    if (_notificationsEnabled) {
      await NotificationService.instance.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: "Emergency Blood Request",
        body:
            "Blood Group ${request.bloodGroup} needed in ${request.city}. Please help!",
      );
    }

    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Emergency sent to nearby ${request.bloodGroup} donors in ${request.city}"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _city.dispose();
    _group.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text("Emergency Request"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.black87]),
            ),
          )),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black87, Colors.red]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          "Enter details to notify nearby donors immediately.",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        _glassTextField(
                            controller: _city, label: "City / Location"),
                        const SizedBox(height: 12),
                        _glassTextField(
                            controller: _group,
                            label: "Required Blood Group (e.g., O+, A-)"),
                        const SizedBox(height: 12),
                        _glassTextField(
                            controller: _contact,
                            label: "Contact number (optional)",
                            keyboardType: TextInputType.phone),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                              value: _notificationsEnabled,
                              activeColor: Colors.red,
                              onChanged: (v) async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('notifications', v);
                                setState(() => _notificationsEnabled = v);
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text("Notify nearby donors",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _submitting ? null : _submitRequest,
                            icon: const Icon(Icons.notifications_active),
                            label: _submitting
                                ? const Text("Notifying...")
                                : const Text("Notify Nearby Donors"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              elevation: 8,
                            ),
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

  Widget _glassTextField(
      {required TextEditingController controller,
      required String label,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
