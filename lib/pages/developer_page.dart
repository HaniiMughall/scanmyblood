import 'package:flutter/material.dart';
import 'package:scanmyblood/utils/app_localization.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc?.translate("developer") ?? "Developer")),
      body: Center(
        child: Text(
          loc?.translate("developer_page") ?? "This is Developer Page",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
