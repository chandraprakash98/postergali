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
      'image': 'assets/images/onboarding_1.png',
    },
    {
      'title': 'Offers ya job\nchahiye?',
      'subtitle': 'PosterGali jaiye..',
      'button': 'Let’s Go',

      /// SECOND SLIDER IMAGE
      'image': 'assets/images/onboarding_2.png',
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
          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              'assets/images/img_6.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFF6F1E7),
                );
              },
            ),
          ),

          /// LIGHT OVERLAY
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF3DFB3).withOpacity(0.78),
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
                    horizontal: 28,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      /// TITLE
                      Text(
                        slide['title'] ?? '',
                        style: TextStyle(
                          fontSize: index == 1 ? 40 : 42,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          color: AppColors.golden,

                          /// SAME SHADOW STYLE
                          shadows: const [
                            Shadow(
                              offset: Offset(2.5, 2.5),
                              blurRadius: 0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SUBTITLE
                      Text(
                        slide['subtitle'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.35,
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// IMAGE CARD
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(


                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            slide['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                AppAssets.onboarding1,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 34),

                      /// BUTTONS
                      Row(
                        children: [
                          if (index == 0)
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
                            )
                          else
                            const SizedBox(width: 20),

                          const Spacer(),

                          Expanded(
                            flex: index == 1 ? 1 : 0,
                            child: GestureDetector(
                              onTap: _goToNextPage,
                              child: Container(
                                height: 68,
                                width:
                                index == 1 ? double.infinity : 190,
                                decoration: BoxDecoration(
                                  color: index == 0
                                      ? AppColors.golden
                                      : AppColors.primaryRed,
                                  borderRadius:
                                  BorderRadius.circular(40),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slide['button'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    if (index == 0) ...[
                                      const SizedBox(width: 10),

                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ],
                                ),
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