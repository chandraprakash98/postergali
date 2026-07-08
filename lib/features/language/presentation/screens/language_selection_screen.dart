import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:postergali/core/localization/localization_service.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../location/location_permission_screen.dart';
import '../../../location/presentation/screens/location_selector_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends State<LanguageSelectionScreen> {

  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = LocalizationService().isHindi ? "हिंदी" : "English";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationStatus();
    });
  }

  Future<void> _checkLocationStatus() async {
    bool locationEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (!locationEnabled && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LocationPermissionScreen(),
        ),
      );
    }
  }

  void _goToLocationSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPermissionScreen(),
      ),
    );
  }

  Widget buildLanguageTile({
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
        height: 70, // reduced from 102
        margin: const EdgeInsets.only(bottom: 16), // reduced from 26
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4EAC7).withOpacity(0.78),
          borderRadius: BorderRadius.circular(30), // reduced from 42
          border: Border.all(
            color: const Color(0xFFB6402C),
            width: 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20, // reduced from 24
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
                fontSize: 18, // reduced from 24
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background (Same as Onboarding Slide 1)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFAE2BC),
                    Color(0xFFFFF2CC),
                    Color(0xFFEFDFAE),
                  ],
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/img.png'),
                  fit: BoxFit.cover,
                  opacity: 0.10,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
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

                  buildLanguageTile(title: "English", localeCode: 'en'),
                  buildLanguageTile(title: "हिंदी", localeCode: 'hi'),

                  const Spacer(),

                  GestureDetector(
                    onTap: _goToLocationSelector,
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

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}