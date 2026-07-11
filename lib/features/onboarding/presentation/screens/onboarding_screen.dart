import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/img_7.png'), context);
    precacheImage(const AssetImage('assets/images/img_11.png'), context);
    precacheImage(const AssetImage('assets/images/img.png'), context);
  }

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
                    Color(0xFFFAE2BC), // Light Cream
                    Color(0xFFFFF2CC), // Cream
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
              itemCount: 2,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildFirstSlide();
                }

                return _buildSecondSlide();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.golden,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  'assets/images/img_7.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Stack(
            children: [
              Text(
                context.tr('onboarding_title_1'),
                style: TextStyle(
                  fontSize: 44,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 3.4
                    ..color = Colors.black,
                ),
              ),
              Text(
                context.tr('onboarding_title_1'),
                style: const TextStyle(
                  fontSize: 44,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                  color: AppColors.golden,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            context.tr('onboarding_subtitle_1'),
            style: const TextStyle(
              fontSize: 18,
              height: 1.35,
              color: Color(0xFF83382D),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 30),

          Row(
            children: [
              GestureDetector(
                onTap: _skip,
                child: Text(
                  context.tr('skip'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('next'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
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

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildSecondSlide() {
    return Stack(
      children: [
        /// FULL BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            'assets/images/img_11.png',
            fit: BoxFit.cover,
          ),
        ),

        /// BOTTOM BLUR REPLACED WITH GRADIENT FOR PERFORMANCE
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0x00FFF8E8),
                  const Color(0xCCF6E8BF),
                  const Color(0xEEF8D990),
                  const Color(0xFFF5E3BC),
                ],
                stops: const [
                  0.0,
                  0.30,
                  0.65,
                  1.0,
                ],
              ),
            ),
          ),
        ),

        /// TEXT
        Positioned(
          left: 32,
          right: 32,
          bottom: 135,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Text(
                    context.tr('onboarding_title_2'),
                    style: TextStyle(
                      fontSize: 47,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    context.tr('onboarding_title_2'),
                    style: const TextStyle(
                      fontSize: 47,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: AppColors.golden,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                context.tr('onboarding_subtitle_2'),
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF83382D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        /// BUTTON
        Positioned(
          left: 25,
          right: 25,
          bottom: 40,
          child: GestureDetector(
            onTap: _goToLanguageScreen,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFB34233),
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('lets_begin'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}