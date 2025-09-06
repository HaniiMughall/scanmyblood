import 'package:flutter/material.dart';
import 'dart:ui';
import 'home_page.dart';
import 'package:scanmyblood/gamification/screens/gamification_screen.dart';
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
    ProfilePage(),
    HistoryPage(),
    AdminPanelPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF8B0000), // Dark red background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Scan My Blood",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B0000), Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.white),
            onPressed: widget.toggleTheme,
            tooltip: 'Toggle Theme',
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: widget.toggleLanguage,
            tooltip: 'Toggle Language',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamificationScreen()),
              );
            },
            tooltip: 'Gamification',
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8B0000).withOpacity(0.9), Colors.black87],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text("Menu",
                    style: TextStyle(color: Colors.white, fontSize: 28)),
              ),
              _drawerItem(Icons.admin_panel_settings, "Admin Panel", 3),
              _drawerItem(Icons.history, "History", 2),
              _drawerItem(Icons.person, "Profile", 1),
              _drawerItem(Icons.settings, "Settings", 4),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.1),
            currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.white70,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: "History"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings), label: "Admin"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        _onItemTapped(index);
        Navigator.pop(context);
      },
    );
  }
}
