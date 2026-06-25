import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../home/presentation/screens/home_screen.dart';
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

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();

      // If user previously confirmed a location we saved it under "saved_locations".
      // If present, navigate directly to HomeScreen with that location.
      final saved = prefs.getStringList("saved_locations") ?? [];
      if (saved.isNotEmpty) {
        try {
          final first = jsonDecode(saved.first) as Map<String, dynamic>;
          final location = first["address"] ?? first["city"] ?? "";
          final lat = (first["lat"] is num) ? (first["lat"] as num).toDouble() : double.tryParse("${first["lat"]}") ?? 0.0;
          final lng = (first["lng"] is num) ? (first["lng"] as num).toDouble() : double.tryParse("${first["lng"]}") ?? 0.0;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                location: location,
                latitude: lat,
                longitude: lng,
              ),
            ),
          );
          return;
        } catch (_) {
          // Fallthrough to onboarding if parsing fails
        }
      }

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