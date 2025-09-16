import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/signup_screen.dart';
import 'pages/main_page.dart';

// Models
import 'models/user.dart';
import 'models/donor.dart';
import 'models/blood_request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Hive init
  await Hive.initFlutter();

  // ✅ Register adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DonorAdapter());
  Hive.registerAdapter(BloodRequestAdapter());
  Hive.registerAdapter(RequestStatusAdapter());

  // ✅ Open boxes
  await Hive.openBox<User>("users");
  await Hive.openBox<Donor>("donors");
  await Hive.openBox<BloodRequest>("requests");
  await Hive.openBox("pending"); // generic box
  await Hive.openBox("authBox"); // ✅ to store login state

  runApp(const ScanMyBloodApp());
}

class ScanMyBloodApp extends StatefulWidget {
  const ScanMyBloodApp({super.key});

  @override
  State<ScanMyBloodApp> createState() => _ScanMyBloodAppState();
}

class _ScanMyBloodAppState extends State<ScanMyBloodApp> {
  bool _isDarkMode = false;
  bool _isEnglish = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
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
      title: "Scan My Blood",
      debugShowCheckedModeBanner: false,

      // ✅ Theme handling
      theme: ThemeData(primarySwatch: Colors.red),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ✅ Routes
      initialRoute: "/splash",
      routes: {
        "/splash": (_) => const SplashScreen(),
        "/login": (_) => const LoginScreen(),
        "/signup": (_) => const SignUpScreen(),
        "/onboarding": (_) => const OnboardingScreen(),
        "/main": (_) => MainPage(
              toggleTheme: _toggleTheme,
              toggleLanguage: _toggleLanguage,
              isDarkMode: _isDarkMode,
              isEnglish: _isEnglish,
            ),
      },
    );
  }
}
