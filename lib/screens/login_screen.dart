import 'package:flutter/material.dart';
import 'package:scanmyblood/services/database_service.dart';
import 'onboarding_screen.dart';
import 'signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill email and password")));
      return;
    }

    setState(() => _loading = true);

    final ok = await DatabaseService.instance.validateUser(email, pass);

    setState(() => _loading = false);

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Account not found. Please sign up first.")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_email', email);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bloodtype,
                            size: 80, color: Colors.white),
                        const SizedBox(height: 20),
                        const Text(
                          "Scan My Blood",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Email Field
                        TextFormField(
                          controller: emailCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: _glassDecoration("Email"),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Enter email";
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(val)) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        // Password Field
                        TextFormField(
                          controller: passCtrl,
                          obscureText: _obscure,
                          style: const TextStyle(color: Colors.white),
                          decoration: _glassDecoration("Password").copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Enter password";
                            }
                            if (val.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              backgroundColor: Colors.redAccent,
                              foregroundColor:
                                  Colors.white, // ✅ text white hoga
                              shadowColor: Colors.black.withOpacity(0.4),
                              elevation: 8,
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Login",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Sign up
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()));
                          },
                          child: const Text(
                            "Don’t have an account? Sign Up",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _glassDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
