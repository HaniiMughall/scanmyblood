import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  const AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _SimpleDelegate();

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  String translate(String key) {
    // Minimal mapping for used keys
    final common = {
      'welcome': 'Welcome',
      'menu': 'Menu',
      'admin': 'Admin Panel',
      'developer': 'Developer View',
      'history': 'History',
      'profile': 'Profile',
      'home': 'Home',
      'compatibility': 'Compatibility',
      'donors': 'Donors',
      'find_donor': 'Find Donor',
      'request_blood': 'Request Blood',
      'detected_blood': 'Detected Blood Group',
      'start_scan': 'Start Scan',
      'view_donors': 'View Compatible Donors',
    };
    return common[key] ?? key;
  }

  bool get isRTLLanguage => locale.languageCode == 'ur';
}

class _SimpleDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _SimpleDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'ur'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
