import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

import 'package:scanmyblood/services/database_service.dart';
import 'package:scanmyblood/services/sync_manager.dart';
import 'package:scanmyblood/models/user_adapter.dart';
import 'models/donor_adapter.dart';
import 'models/blood_request_adapter.dart';
import 'package:scanmyblood/screens/splash_screen.dart';
import 'package:scanmyblood/screens/login_screen.dart';
import 'package:scanmyblood/screens/signup_screen.dart';
import 'package:scanmyblood/screens/onboarding_screen.dart';
import 'package:scanmyblood/pages/main_page.dart';
import 'package:scanmyblood/pages/predict_page.dart';

// Gamification imports
import 'package:scanmyblood/gamification/providers/gamification_provider.dart';
import 'package:scanmyblood/gamification/services/gamification_service.dart';
import 'package:scanmyblood/gamification/models/achievement.dart';

// AI Services (Offline + Online)
import './services/tflite_service.dart';
import 'package:scanmyblood/services/api_service.dart';
import 'package:scanmyblood/services/prediction_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DonorAdapter());
  Hive.registerAdapter(BloodRequestAdapter());

  await DatabaseService.instance.init();

  Connectivity().onConnectivityChanged.listen((status) {
    if (status != ConnectivityResult.none) {
      SyncManager.trySyncPending();
    }
  });

  final prefs = await SharedPreferences.getInstance();

  final achievements = [
    Achievement(
      id: "donate1",
      title: "First Donation",
      description: "Donate blood for the first time",
      pointsReward: 50,
    ),
    Achievement(
      id: "donate3",
      title: "Hero Donor",
      description: "Donate blood 3 times",
      pointsReward: 150,
      oneTime: true,
      target: 3,
    ),
    Achievement(
      id: "streak7",
      title: "One Week Streak",
      description: "Open the app for 7 days in a row",
      pointsReward: 100,
      oneTime: true,
      target: 7,
    ),
  ];

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GamificationProvider(
            service: GamificationService(),
            achievementsDefinition: achievements,
          ),
        ),
      ],
      child: BloodApp(prefs: prefs),
    ),
  );
}

class BloodApp extends StatefulWidget {
  final SharedPreferences prefs;
  const BloodApp({super.key, required this.prefs});

  @override
  State<BloodApp> createState() => _BloodAppState();
}

class _BloodAppState extends State<BloodApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isEnglish = true;

  void toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanMyBlood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/home': (_) => MainPage(
              toggleTheme: toggleTheme,
              toggleLanguage: toggleLanguage,
              isDarkMode: _themeMode == ThemeMode.dark,
              isEnglish: _isEnglish,
            ),
        '/predict': (_) => const PredictPage(), // <-- Ye line add karo
      },
    );
  }
}
