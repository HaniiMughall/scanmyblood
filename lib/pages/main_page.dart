import 'package:flutter/material.dart';
import 'home_page.dart';
import 'compatibility_page.dart';
import 'donor_list_page.dart';
import 'profile_page.dart';
import 'history_page.dart';
import 'admin_panel_page.dart';
import 'developer_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleLanguage;
  final bool isDarkMode;
  final bool isEnglish;

  MainPage({
    super.key,
    required this.toggleTheme,
    required this.toggleLanguage,
    required this.isDarkMode,
    required this.isEnglish,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        toggleTheme: widget.toggleTheme,
        toggleLanguage: widget.toggleLanguage,
        isDarkMode: widget.isDarkMode,
        isEnglish: widget.isEnglish,
      ),
      CompatibilityPage(myGroup: ""), // default empty
      const DonorListPage(),
      const ProfilePage(),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Scan My Blood"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: Colors.black.withOpacity(0.85),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  "Scan My Blood",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
              _buildDrawerItem(
                  Icons.admin_panel_settings,
                  "Admin Panel",
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AdminPanelPage()))),
              _buildDrawerItem(
                  Icons.developer_mode,
                  "Developer View",
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DeveloperPage()))),
              _buildDrawerItem(
                  Icons.history,
                  "History Panel",
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const HistoryPage()))),
              _buildDrawerItem(
                  Icons.person,
                  "Profile",
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()))),
            ],
          ),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.black87, Colors.red],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            onTap: (i) => setState(() => _selectedIndex = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bloodtype), label: "Compatibility"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.people), label: "Donors"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
