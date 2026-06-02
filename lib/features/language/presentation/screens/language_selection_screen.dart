import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  String selectedLanguage = "English";

  @override
  void initState() {
    super.initState();

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
  }) {
    final bool isSelected = selectedLanguage == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 102,
        margin: const EdgeInsets.only(bottom: 26),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF2EFE4).withOpacity(0.78),
          borderRadius: BorderRadius.circular(42),
          border: Border.all(
            color: const Color(0xFFB6402C),
            width: 1.6,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFB6402C),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB6402C),
                  ),
                ),
              )
                  : null,
            ),

            const SizedBox(width: 20),

            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
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
      backgroundColor: const Color(0xFFF6F1E7),
      body: Stack(
        children: [
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

          Positioned.fill(
            child: Container(
              color: const Color(0xFFF6F1E7).withOpacity(0.84),
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

                  const Text(
                    "Welcome to PosterGali",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF8B2D24),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    "Choose your\nlanguage",
                    style: TextStyle(
                      fontSize: 50,
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

                  buildLanguageTile(title: "English"),
                  buildLanguageTile(title: "हिंदी"),

                  const Spacer(),

                  GestureDetector(
                    onTap: _goToLocationSelector,
                    child: Container(
                      height: 74,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.golden,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Proceed",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
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