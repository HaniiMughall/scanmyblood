import 'package:flutter/material.dart';
import 'pages/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BloodApp());
}

class BloodApp extends StatefulWidget {
  const BloodApp({super.key});

  @override
  State<BloodApp> createState() => _BloodAppState();
}

class _BloodAppState extends State<BloodApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isEnglish = true;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan My Blood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: MainPage(
        toggleTheme: _toggleTheme,
        toggleLanguage: _toggleLanguage,
        isDarkMode: _themeMode == ThemeMode.dark,
        isEnglish: _isEnglish,
      ),
    );
  }
}
