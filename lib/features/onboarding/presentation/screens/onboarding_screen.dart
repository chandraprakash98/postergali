import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../language/presentation/screens/language_selection_screen.dart';
import '../../../location/location_permission_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  int _selectedOption = -1;
  String selectedLanguage = "English";

  // Dynamic sequence based on selection
  List<int> _pageSequence = [0, 1, 2, 3]; // Default

  @override
  void initState() {
    super.initState();
    selectedLanguage = LocalizationService().isHindi ? "हिंदी" : "English";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/img_7.png'), context);
    precacheImage(const AssetImage('assets/images/img_11.png'), context);
    precacheImage(const AssetImage('assets/images/img_14.png'), context);
    precacheImage(const AssetImage('assets/images/img.png'), context);
  }

  void _updateSequence(int option) {
    setState(() {
      _selectedOption = option;
      if (option == 0) {
        // Grow Business -> Show "third slider" (Aamdani/Title 1) -> Language
        // Maps to realIndex 1 in itemBuilder
        _pageSequence = [0, 1, 3];
      } else {
        // Find Deals/Job -> Show "second slider" (Offers/Title 2) -> Language
        // Maps to realIndex 2 in itemBuilder
        _pageSequence = [0, 2, 3];
      }
    });
  }

  void _goToNextPage() {
    if (_currentPage < _pageSequence.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLocationSelector();
    }
  }

  void _skip() {
    // Skip to language slide (the last one in sequence)
    _pageController.animateToPage(
      _pageSequence.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _goToLocationSelector() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList("saved_locations") ?? [];

    if (saved.isNotEmpty && mounted) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
        return;
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LocationPermissionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND (Same as Splash)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFAE2BC), // Light Cream
                    Color(0xFFFFF2CC), // Cream
                    Color(0xFFEFDFAE), // Warm Beige
                  ],
                ),
              ),
            ),
          ),

          /// MAIN CONTENT
          SafeArea(
            child: Column(
              children: [
                /// PROGRESS INDICATOR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    children: List.generate(_pageSequence.length, (index) {
                      return Expanded(
                        child: Container(
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index <= _currentPage
                                ? const Color(0xFFFFB124)
                                : const Color(0xFFB34233).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageSequence.length,
                    onPageChanged: (value) {
                      setState(() {
                        _currentPage = value;
                      });
                    },
                    itemBuilder: (context, index) {
                      final int realIndex = _pageSequence[index];
                      if (realIndex == 0) {
                        return _buildFirstSlide();
                      } else if (realIndex == 1) {
                        return _buildThirdSlide(); // "Lagao Aamdani"
                      } else if (realIndex == 2) {
                        return _buildSecondSlide(); // "Offers ya Job"
                      } else {
                        return _buildLanguageSlide();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstSlide() {
    return Stack(
      children: [
        /// TOP IMAGE
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            'assets/images/img_15.png',
            width: double.infinity,
            height: 240,
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),

        /// CONTENT
        Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Stack(
                  children: [
                    Text(
                      context.tr('onboarding_title_3'),
                      style: TextStyle(
                        fontSize: 46,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.5
                          ..color = const Color(0xFF333333),
                      ),
                    ),
                    /// Fill + Shadow
                    Text(
                      context.tr('onboarding_title_3'),
                      style: const TextStyle(
                        fontSize: 46,
                        height: 1.15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFAA24B),
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            offset: Offset(1, 2), // X:1, Y:2
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// SUBTITLE
                Text(
                  context.tr('onboarding_subtitle_3'),
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    color: Color(0xFF83382D),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                _buildOption(0, context.tr('grow_business')),
                const SizedBox(height: 12),
                _buildOption(1, context.tr('find_deals')),
                const SizedBox(height: 12),
                _buildOption(2, context.tr('find_job')),

                const Spacer(),

                /// BUTTON
                GestureDetector(
                  onTap: () {
                    if (_selectedOption != -1) {
                      _goToNextPage();
                    }
                  },
                  child: Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                      color: _selectedOption != -1
                          ? const Color(0xFFB34233)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        if (_selectedOption != -1)
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
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildSecondSlide() {
    return Stack(
      children: [
        /// FULL SCREEN IMAGE
        Positioned.fill(
          child: Image.asset(
            'assets/images/img_14.png',
            fit: BoxFit.cover,
          ),
        ),

        /// BOTTOM GRADIENT
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 360,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00FFF8E8), // Transparent
                  Color(0xCCE8DFC3), // 80% opacity
                  Color(0xF2E8DFC3), // 95% opacity
                  Color(0xFFE8DFC3), // 100% opacity
                ],
                stops: [
                  0.0,
                  0.25,
                  0.55,
                  1.0,
                ],
              ),
            ),
          ),
        ),

        /// CONTENT
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(),

                /// TITLE
                Stack(
                  children: [
                    Text(
                      context.tr('onboarding_title_2'),
                      style: TextStyle(
                        fontSize: 46,
                        height: .95,
                        fontWeight: FontWeight.w900,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black,
                      ),
                    ),
                    const SizedBox(),

                    Text(
                      context.tr('onboarding_title_2'),
                      style: const TextStyle(
                        fontSize: 46,
                        height: .95,
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

                const SizedBox(height: 45),

                /// BUTTON ROW
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
                        height: 60,
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB34233),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThirdSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: Column(
        children: [
          /// IMAGE
          Expanded(
            flex: 6,
            child: Image.asset(
              'assets/images/img_7.png',
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          const SizedBox(height: 10),

          /// TEXT AREA
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Stack(
                    children: [
                      /// Shadow
                      Transform.translate(
                        offset: const Offset(2, 3),
                        child: Text(
                          context.tr('onboarding_title_1'),
                          style: const TextStyle(
                            fontSize: 45,
                            height: .99,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff8A4328),
                          ),
                        ),
                      ),

                      /// Outline
                      Text(
                        context.tr('onboarding_title_1'),
                        style: TextStyle(
                          fontSize: 45,
                          height: .99,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = const Color(0xff222222),
                        ),
                      ),

                      /// Fill
                      const SizedBox(),

                      Text(
                        context.tr('onboarding_title_1'),
                        style: const TextStyle(
                          fontSize: 45,
                          height: .99,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffF2AD36),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// SUBTITLE
                  Text(
                    context.tr('onboarding_subtitle_1'),
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.25,
                      color: Color(0xffc3452a),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  /// BOTTOM BUTTONS
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _skip,
                        child: Text(
                          context.tr('skip'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffB34233),
                          ),
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: _goToNextPage,
                        child: Container(
                          width: 132,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xffB34233),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.20),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr('next'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLanguageSlide() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 34,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 26),
          Text(
            context.tr('welcome'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8B2D24),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            context.tr('choose_language'),
            style: const TextStyle(
              fontSize: 36,
              height: 1.0,
              fontWeight: FontWeight.w900,
              color: AppColors.golden,
              shadows: [
                Shadow(
                  offset: Offset(3, 3),
                  blurRadius: 0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(height: 54),
          _buildLanguageTile(title: "English", localeCode: 'en'),
          _buildLanguageTile(title: "हिंदी", localeCode: 'hi'),
          const Spacer(),
          GestureDetector(
            onTap: _goToNextPage,
            child: Container(
              height: 58,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.golden,
                borderRadius: BorderRadius.circular(45),
              ),
              alignment: Alignment.center,
              child: Text(
                context.tr('proceed'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLanguageTile({
    required String title,
    required String localeCode,
  }) {
    final bool isSelected = selectedLanguage == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = title;
        });
        LocalizationService().changeLocale(localeCode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 70,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAF7E9).withOpacity(0.78),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFB6402C),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB6402C),
                  width: 1.3,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB6402C),
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(int index, String title) {
    final bool isSelected = _selectedOption == index;

    return GestureDetector(
      onTap: () {
        _updateSequence(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFAA24B) : Colors.white.withOpacity(0.82),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? const Color(0xFF7A241A) : const Color(0xFF333333).withOpacity(0.18),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.18 : 0.08),
              offset: const Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : const Color(0xFFB34233),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Color(0xFFB34233),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : const Color(0xFF4A1F14),
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
