import 'package:flutter/material.dart';

import 'features/splash_screen.dart';

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
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
