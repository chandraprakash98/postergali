import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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

  void _goToLocationSelector() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationSelectorScreen(),
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
      child: Container(
        height: 78,
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            /// RADIO BUTTON
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 22),
            /// LANGUAGE TEXT
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              /// SMALL TEXT
              const Text(
                "Welcome to PosterGali..",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              /// BIG TITLE
              const Text(
                "Choose your\nLanguage",
                style: TextStyle(
                  fontSize: 54,
                  height: 1.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 46),
              /// ENGLISH
              buildLanguageTile(
                title: "English",
              ),
              /// HINDI
              buildLanguageTile(
                title: "हिंदी",
              ),
              const Spacer(),
              /// PROCEED BUTTON
              GestureDetector(
                onTap: _goToLocationSelector,
                child: Container(
                  height: 72,
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
    );
  }
}
