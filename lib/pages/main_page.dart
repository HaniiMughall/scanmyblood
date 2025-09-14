import 'package:flutter/material.dart';
import 'home_page.dart';
import '/gamification/screens/gamification_screen.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'admin_panel_page.dart';
import 'setting_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleLanguage;
  final bool isDarkMode;
  final bool isEnglish;

  const MainPage({
    super.key,
    required this.toggleTheme,
    required this.toggleLanguage,
    required this.isDarkMode,
    required this.isEnglish,
  });

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    HomePage(),
    const ProfilePage(),
    const HistoryPage(),
    const AdminPanelPage(),
    const SettingsPage(),
    const GamificationScreen(), // <-- add gamification as a main page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.red.shade900 : Colors.white70,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.red.shade900),
              child: const Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Admin Panel"),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Gamification"),
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: const Text(
          "Scan My Blood",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 6,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: () {
              widget.toggleTheme();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () {
              widget.toggleLanguage();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.white),
            onPressed: () {
              _onItemTapped(5); // <-- switch to gamification page
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.person, "Profile", 1),
            _buildNavItem(Icons.history, "History", 2),
            _buildNavItem(Icons.admin_panel_settings, "Admin", 3),
          ],
        ),
      ),
    );
  }
}
