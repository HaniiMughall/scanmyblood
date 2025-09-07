import 'package:flutter/material.dart';

class ThemedPage extends StatelessWidget {
  final String title;
  final Widget child;

  const ThemedPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 8, // ✅ zyada shadow
        iconTheme: const IconThemeData(color: Colors.white),
        shadowColor: Colors.black
            .withOpacity(0.4), // ✅ shadow ko dark aur visible banata hai
      ),

      backgroundColor: Colors.red.shade900, // ✅ light red bg for contrast
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500, // ✅ box ki max width fix
                maxHeight: MediaQuery.of(context).size.height *
                    0.75, // ✅ box ki max height fix
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
