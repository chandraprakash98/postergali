import 'package:flutter/material.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'core/constants/app_colors.dart';

void main() {
  runApp(const PosterGaliApp());
}

class PosterGaliApp extends StatelessWidget {
  const PosterGaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PosterGali',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
        ),
        fontFamily: 'HelveticaNeue',
      ),
      home: const SplashScreen(),
    );
  }
}
