import 'package:flutter/material.dart';
import 'package:scanmyblood/utils/global_data.dart';
import 'package:scanmyblood/services/database_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    // Load saved preferences if you have (optional)
    // For demo, default true/false
  }

  void _logout() {
    // Clear current user
    currentUser = null;
    // Navigate to login page (replace as per your route)
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // ===== Profile =====
          const Text("Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person),
              title: Text(currentUser?.name ?? 'Guest'),
              subtitle: Text(currentUser?.email ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // TODO: Add profile edit page
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ===== Notifications =====
          const Text("Notifications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text("Emergency Alerts"),
            value: notificationsEnabled,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          SwitchListTile(
            title: const Text("Daily Donation Reminders"),
            value: !notificationsEnabled ? false : true,
            onChanged: (val) => setState(() => notificationsEnabled = val),
          ),
          const SizedBox(height: 16),

          // ===== Theme =====
          const Text("Appearance",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: darkModeEnabled,
            onChanged: (val) => setState(() => darkModeEnabled = val),
          ),
          const SizedBox(height: 16),

          // ===== App Info =====
          const Text("App Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Version"),
              subtitle: const Text("1.0.0"),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Terms & Privacy"),
              onTap: () {
                // TODO: Open terms/privacy page or dialog
              },
            ),
          ),
          const SizedBox(height: 16),

          // ===== Logout =====
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}
