import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanmyblood/models/user.dart';
import 'package:scanmyblood/services/database_service.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  User? _user;
  bool _editing = false;
  final _name = TextEditingController();
  final _blood = TextEditingController();
  final _contact = TextEditingController();
  final _about = TextEditingController();

  File? _profileImage;

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _loadUser();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
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
        _about.text = u.about ?? '';

        if (u.profileImagePath != null) {
          _profileImage = File(u.profileImagePath!);
        }
      }
    });
  }

  Future<void> _save() async {
    if (_user == null) return;
    _user!.name = _name.text.trim();
    _user!.bloodGroup = _blood.text.trim().isEmpty ? null : _blood.text.trim();
    _user!.contact = _contact.text.trim().isEmpty ? null : _contact.text.trim();
    _user!.about = _about.text.trim().isEmpty ? null : _about.text.trim();

    if (_profileImage != null) {
      _user!.profileImagePath = _profileImage!.path;
    }

    await DatabaseService.instance.addUser(_user!);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile updated")));
    setState(() => _editing = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);

        if (_user != null) {
          _user!.profileImagePath = picked.path;
        }
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _blood.dispose();
    _contact.dispose();
    _about.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: Text("No user logged in")));
    }
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeIn,
        child: Column(
          children: [
            // Header with gradient and profile picture
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade900, Colors.red.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Text(
                                _user!.name.isNotEmpty ? _user!.name[0] : 'U',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.red.shade900, width: 2),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(Icons.camera_alt,
                                color: Colors.red.shade900, size: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _user!.about?.isNotEmpty == true
                        ? _user!.about!
                        : "Hey there! I am using this app.",
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Info Section
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: !_editing
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        children: [
                          _buildInfoCard(Icons.bloodtype, "Blood Group",
                              _user!.bloodGroup ?? "N/A"),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                              Icons.phone, "Contact", _user!.contact ?? "N/A"),
                          const SizedBox(height: 12),
                          _buildInfoCard(Icons.info_outline, "About",
                              _user!.about ?? "Hey there! I am using this app."),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () =>
                                setState(() => _editing = !_editing),
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        children: [
                          TextField(
                              controller: _name,
                              decoration:
                                  const InputDecoration(labelText: "Name")),
                          const SizedBox(height: 12),
                          TextField(
                              controller: _blood,
                              decoration: const InputDecoration(
                                  labelText: "Blood Group")),
                          const SizedBox(height: 12),
                          TextField(
                              controller: _contact,
                              decoration:
                                  const InputDecoration(labelText: "Contact")),
                          const SizedBox(height: 12),
                          TextField(
                              controller: _about,
                              decoration:
                                  const InputDecoration(labelText: "About")),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () =>
                                      setState(() => _editing = false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _save,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade900,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.red.shade900),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(value,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ),
      ),
    );
  }
}
