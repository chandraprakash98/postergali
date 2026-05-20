import 'package:flutter/material.dart';
import 'onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Theme Colors
  final Color primaryColor = const Color(0xFFF2AD36);
  final Color secondaryColor = const Color(0xFFCF5C4C);
  final Color accentColor = const Color(0xFF448655);

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              'assets/images/plogo.png',
              height: 140,
              width: 140,
            ),

            const SizedBox(height: 24),

            // App Name
            Text(
              'PosterGali',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            Text(
              'Your Local Ads Marketplace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: accentColor,
              ),
            ),

            const SizedBox(height: 40),

            // Loader
            CircularProgressIndicator(
              color: secondaryColor,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}