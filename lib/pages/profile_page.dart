import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanmyblood/models/user.dart';
import 'package:scanmyblood/services/database_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  bool _editing = false;
  final _name = TextEditingController();
  final _blood = TextEditingController();
  final _contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('logged_in_email');
    if (email == null) return;
    final u = await DatabaseService.instance.getUser(email);
    setState(() {
      _user = u;
      if (u != null) {
        _name.text = u.name;
        _blood.text = u.bloodGroup ?? '';
        _contact.text = u.contact ?? '';
      }
    });
  }

  Future<void> _save() async {
    if (_user == null) return;
    _user!.name = _name.text.trim();
    _user!.bloodGroup = _blood.text.trim().isEmpty ? null : _blood.text.trim();
    _user!.contact = _contact.text.trim().isEmpty ? null : _contact.text.trim();
    await DatabaseService.instance.addUser(_user!);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile updated")));
    setState(() => _editing = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _blood.dispose();
    _contact.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: Text("No user logged in")));
    }
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.red),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
                radius: 40,
                child: Text(_user!.name.isNotEmpty ? _user!.name[0] : 'U')),
            const SizedBox(height: 12),
            if (!_editing) ...[
              Text(_user!.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(_user!.email),
              const SizedBox(height: 12),
              Text("Blood Group: ${_user!.bloodGroup ?? 'N/A'}"),
              const SizedBox(height: 6),
              Text("Contact: ${_user!.contact ?? 'N/A'}"),
            ] else ...[
              TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: "Name")),
              const SizedBox(height: 8),
              TextField(
                  controller: _blood,
                  decoration: const InputDecoration(labelText: "Blood Group")),
              const SizedBox(height: 8),
              TextField(
                  controller: _contact,
                  decoration: const InputDecoration(labelText: "Contact")),
            ],
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => setState(() => _editing = !_editing),
                    child: Text(_editing ? "Cancel" : "Edit")),
                const SizedBox(width: 12),
                if (_editing)
                  ElevatedButton(onPressed: _save, child: const Text("Save")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
