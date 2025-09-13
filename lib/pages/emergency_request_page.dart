import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/notification_service.dart';
import '../../models/blood_request.dart';
import '../../services/database_service.dart';
import 'package:uuid/uuid.dart';
import '/widgets/theme_page.dart';

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
        const SnackBar(content: Text("Enter city & blood group")),
      );
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Emergency sent to nearby ${request.bloodGroup} donors in ${request.city}"),
        ),
      );
      Navigator.pop(context);
    }
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
    return ThemedPage(
      title: "Emergency Request",
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Enter details to notify nearby donors immediately.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                _textField(controller: _city, label: "City / Location"),
                const SizedBox(height: 12),
                _textField(
                    controller: _group,
                    label: "Required Blood Group (e.g., O+, A-)"),
                const SizedBox(height: 12),
                _textField(
                  controller: _contact,
                  label: "Contact number (optional)",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Switch(
                      value: _notificationsEnabled,
                      activeColor: Colors.red.shade900,
                      onChanged: (v) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('notifications', v);
                        setState(() => _notificationsEnabled = v);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text("Notify nearby donors",
                        style: TextStyle(color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submitting ? null : _submitRequest,
                    icon: const Icon(Icons.notifications_active),
                    label: _submitting
                        ? const Text("Notifying...")
                        : const Text("Notify Nearby Donors"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
