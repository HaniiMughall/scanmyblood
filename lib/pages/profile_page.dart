import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scanmyblood/models/user.dart';
import 'package:scanmyblood/services/database_service.dart';

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

  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _loadUser();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
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
              height: 230,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFe52d27), Color(0xFFff512f)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Text(
                          _user!.name.isNotEmpty ? _user!.name[0] : 'U',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: add image picker functionality here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Profile picture edit coming soon")),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.red),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user!.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _user!.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                        padding: const EdgeInsets.all(20),
                        children: [
                          _buildInfoCard(Icons.bloodtype, "Blood Group",
                              _user!.bloodGroup ?? "N/A"),
                          const SizedBox(height: 12),
                          _buildInfoCard(
                              Icons.phone, "Contact", _user!.contact ?? "N/A"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFe52d27),
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    setState(() => _editing = false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text("Cancel"),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _save,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFe52d27),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text("Save"),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}