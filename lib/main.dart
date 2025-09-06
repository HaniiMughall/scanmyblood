import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
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

      // 👇 first screen: Splash
      initialRoute: '/',

      routes: {
        '/': (context) => const SplashScreen(), // splash first
        '/login': (context) => const LoginScreen(), // after splash
        '/onboarding': (context) => const OnboardingScreen(), // after login
        '/home': (context) => MainPage( // home page
              toggleTheme: _toggleTheme,
              toggleLanguage: _toggleLanguage,
              isDarkMode: _themeMode == ThemeMode.dark,
              isEnglish: _isEnglish,
            ),
      },
    );
  }
}
