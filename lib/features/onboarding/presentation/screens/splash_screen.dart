import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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

    Future.delayed(const Duration(seconds: 2), () {
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              AppAssets.appLogo,
              height: 140,
              width: 140,
            ),

            const SizedBox(height: 24),

            // App Name
            const Text(
              'PosterGali',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.golden,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Your Local Ads Marketplace',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.green,
              ),
            ),

            const SizedBox(height: 40),

            // Loader
            const CircularProgressIndicator(
              color: AppColors.primaryRed,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
