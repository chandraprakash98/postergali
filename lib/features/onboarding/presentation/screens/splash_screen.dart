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
      backgroundColor: const Color(0xFFFFF1C4), // Gold
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                AppAssets.appLogo,
                height: 240,
                width: 340,
                fit: BoxFit.contain,
              ),

              // Remove gap between logo and text
              Transform.translate(
                offset: const Offset(0, -35),
                child: const Text(
                  'PosterGali',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                    color: AppColors.golden,
                    letterSpacing: 1,
                  ),
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -28),
                child: const Text(
                  'Yahan dukaan wale kamaate hain aur grahak bachaate hain',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.green,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const CircularProgressIndicator(
                color: AppColors.primaryRed,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}