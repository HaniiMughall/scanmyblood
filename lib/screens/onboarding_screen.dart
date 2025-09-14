import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to Scan My Blood",
      "subtitle": "Every 2 seconds, someone needs blood. Be a lifesaver!",
      "image": "assets/lang/logo.png",
    },
    {
      "title": "Find Donors Easily",
      "subtitle": "Get instant access to donors nearby with just one tap.",
      "image": "assets/lang/search_donor.png",
    },
    {
      "title": "Donate & Earn Rewards",
      "subtitle": "Save lives, earn points & unlock donor badges!",
      "image": "assets/lang/badge.png",
    },
  ];

  void _nextPage() {
    if (_currentPage == _onboardingData.length - 1) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildImage(String assetPath) {
    return assetPath.isNotEmpty
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Image.asset(assetPath, height: 220, fit: BoxFit.contain),
          )
        : const Icon(Icons.bloodtype, size: 120, color: Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _currentPage == _onboardingData.length - 1;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe52d27), Color(0xFFff512f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _onboardingData.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (c, i) {
                    final item = _onboardingData[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(26),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white24, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: _buildImage(item['image'] ?? ""),
                            ),
                            const SizedBox(height: 40),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Colors.yellowAccent],
                              ).createShader(bounds),
                              child: Text(
                                item['title'] ?? "",
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              item['subtitle'] ?? "",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_onboardingData.length, (i) {
                  final active = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
                    height: 12,
                    width: active ? 34 : 12,
                    decoration: BoxDecoration(
                      gradient: active
                          ? const LinearGradient(
                              colors: [Colors.white, Colors.yellowAccent],
                            )
                          : null,
                      color: active ? null : Colors.white38,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                color: Colors.yellowAccent.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                          : [],
                    ),
                  );
                }),
              ),

              // Buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip
                    TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/main'),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Next / Get Started
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          isLast ? "Get Started" : "Next",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
