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
      backgroundColor: const Color(0xFFFFD583),

      body: Stack(
        children: [

          /// LIGHT OVERLAY
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF3E5B4).withOpacity(0.78),
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

                /// SECOND SCREEN
                if (index == 1) {
                  return Stack(
                    children: [
                      /// FULL PAGE BACKGROUND
                      Positioned.fill(
                        child: Image.asset(
                          slide['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// DARK OVERLAY
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.15),
                        ),
                      ),

                      /// BOTTOM GRADIENT
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 6,
                              sigmaY: 6,
                            ),
                            child: Container(
                              height: 310,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.10),
                                    Colors.black.withOpacity(.30),
                                    Colors.black.withOpacity(.70),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 20,
                          ),
                          child: Column(
                            children: [
                              const Spacer(),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  slide['title']!,
                                  style: const TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amber,
                                    height: 1,
                                    shadows: [
                                      Shadow(offset: Offset(-2, -2), color: Colors.black),
                                      Shadow(offset: Offset(2, -2), color: Colors.black),
                                      Shadow(offset: Offset(-2, 2), color: Colors.black),
                                      Shadow(offset: Offset(2, 2), color: Colors.black),
                                      Shadow(offset: Offset(-2, 0), color: Colors.black),
                                      Shadow(offset: Offset(2, 0), color: Colors.black),
                                      Shadow(offset: Offset(0, -2), color: Colors.black),
                                      Shadow(offset: Offset(0, 2), color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  slide['subtitle']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 35),

                              SizedBox(
                                width: double.infinity,
                                height: 68,
                                child: ElevatedButton(
                                  onPressed: _goToNextPage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryRed,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                  child: const Text("Let's Go"),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                /// FIRST SCREEN (YOUR CURRENT UI)
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Image.asset(
                            slide['image'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Stack(
                        children: [
                          Text(
                            slide['title'] ?? '',
                            style: TextStyle(
                              fontSize: 42,
                              height: 1.08,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 5
                                ..color = Colors.black,
                            ),
                          ),
                          Text(
                            slide['title'] ?? '',
                            style: TextStyle(
                              fontSize: 42,
                              height: 1.08,
                              fontWeight: FontWeight.w900,
                              color: AppColors.golden,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),


                      Text(
                        slide['subtitle'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.35,
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: _skip,
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 20,
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
                              height: 68,
                              width: 190,
                              decoration: BoxDecoration(
                                color: AppColors.golden,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              alignment: Alignment.center,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
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