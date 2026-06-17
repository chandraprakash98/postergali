import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFF5F1E4), // Light Cream
              Color(0xFFF0EAD7), // Cream
              Color(0xFFE8DFC3), // Warm Beige
            ],
          ),
          image: const DecorationImage(
            image: AssetImage(
              'assets/images/img.png',
            ),
            fit: BoxFit.cover,
            opacity: 0.10, // Adjust 0.08 - 0.15 as needed
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// Logo
                Image.asset(
                  AppAssets.splashLogo,
                  width: 320,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 30),

                /// Loader
                const SizedBox(
                  height: 26,
                  width: 26,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(
                      Color(0xFFE49A06),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}