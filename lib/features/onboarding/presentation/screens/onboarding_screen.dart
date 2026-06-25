import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../language/presentation/screens/language_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'PosterGali pe\nlagao aamdani\nbadhao',
      'subtitle':
      '1 minute se kam samay mein\nwoh bhi kifayati daam mein..',
      'button': 'Next',

      /// FIRST SLIDER IMAGE
      'image': 'assets/images/img_7.png',
    },
    {
      'title': 'Offers ya job\nchahiye?',
      'subtitle': 'PosterGali jaiye..',
      'button': 'Let’s Go',

      /// SECOND SLIDER IMAGE
      'image': 'assets/images/img_11.png',
    },
  ];

  void _goToNextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLanguageScreen();
    }
  }

  void _skip() {
    _goToLanguageScreen();
  }

  void _goToLanguageScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LanguageSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND (Same as Splash)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFEDCE9B), // Light Cream
                    Color(0xFFF6DE95), // Cream
                    Color(0xFFEFDFAE), // Warm Beige
                  ],
                ),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/img.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.10,
                ),
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (context, index) {
                final slide = _slides[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      /// IMAGE CARD
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.golden,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              slide['image'] ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// TITLE
                      Stack(
                        children: [
                          Text(
                            slide['title'] ?? '',
                            style: TextStyle(
                              fontSize: 44,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black,
                            ),
                          ),
                          Text(
                            slide['title'] ?? '',
                            style: const TextStyle(
                              fontSize: 44,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                              color: AppColors.golden,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// SUBTITLE
                      Text(
                        slide['subtitle'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.35,
                          color: Color(0xFF83382D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// NAVIGATION
                      Row(
                        children: [
                          if (_currentPage == 0)
                            GestureDetector(
                              onTap: _skip,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "Skip",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _goToNextPage,
                            child: Container(
                              height: 64,
                              width: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB34233),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}