import 'package:flutter/material.dart';
import 'language_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;

  // APP COLORS
  final Color primaryYellow = const Color(0xFFF2AD36);
  final Color primaryRed = const Color(0xFFCF5C4C);

  // ONLY 2 SCREENS NOW
  final List<Map<String, String>> _slides = [
    {
      'title': 'PosterGali\npelagao\naamdani\nbadhao',
      'subtitle':
      '1 minute se kam samay mein\nwoh bhi kifayati daam mein..',
      'button': 'Next',
    },

    // FINAL SCREEN
    {
      'title': 'Offers ya job\nchahiye?',
      'subtitle': 'PosterGali jaiye..',
      'button': 'Let’s Go',
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
      backgroundColor: Colors.white,

      body: SafeArea(
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
                    slide['title']!,
                    style: TextStyle(
                      fontSize: index == 1 ? 40 : 42,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,

                      // OUTLINE EFFECT
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
                    slide['subtitle']!,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.35,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 34),

                  /// IMAGE BOX
                  Expanded(
                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(38),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),

                      child: Center(
                        child: Text(
                          index == 0
                              ? "Poster Preview"
                              : "Illustration",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),

                  /// BOTTOM AREA
                  Row(
                    children: [
                      /// SKIP BUTTON
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

                      /// BUTTON
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
                                  ? primaryYellow
                                  : primaryRed,
                              borderRadius: BorderRadius.circular(40),
                            ),

                            alignment: Alignment.center,

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  slide['button']!,
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
    );
  }
}