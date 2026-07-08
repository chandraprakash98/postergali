import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';

class HomeHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLanguageTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onBannerTap;

  const HomeHeader({
    super.key,
    required this.location,
    required this.onLanguageTap,
    this.onLocationTap,
    this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP HEADER
        Row(
          children: [
            /// LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// APP NAME
                  Text(
                    "PosterGali",
                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 40,
                      height: 1,
                      letterSpacing: -1.1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  /// LOCATION
                  GestureDetector(
                    onTap: onLocationTap,
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      children: [
                        /// LOCATION ICON
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.golden.withOpacity(.22),
                                AppColors.golden.withOpacity(.08),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: AppColors.golden.withOpacity(.18),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/img_12.png', // your image path
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 7),
                        /// LOCATION TEXT
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark.withOpacity(.72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            /// LANGUAGE BUTTON
            Transform.translate(
              offset: const Offset(0, -16), // move up by 10 pixels
              child: GestureDetector(
                onTap: onLanguageTap,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.darkRed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/language.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        /// 3D MATERIAL BANNER
        GestureDetector(
          onTap: onBannerTap,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              width: double.infinity,
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.bannerHome,
                    width: double.infinity,
                    fit: BoxFit.contain, // Shows complete image
                  ),

                  /// LIGHT REFLECTION
                  // Positioned(
                  //   top: -40,
                  //   right: -20,
                  //   child: Container(
                  //     height: 140,
                  //     width: 140,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.white.withOpacity(0.10),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
