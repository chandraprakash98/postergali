import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';

class HomeHeader extends StatelessWidget {
  final String location;
  final VoidCallback onLanguageTap;
  final VoidCallback? onBannerTap;

  const HomeHeader({
    super.key,
    required this.location,
    required this.onLanguageTap,
    this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(34);

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
                      letterSpacing: -1.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  /// LOCATION
                  Row(
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
                        child: const Icon(
                          CupertinoIcons.location_solid,
                          size: 14,
                          color: AppColors.primaryRed,
                        ),
                      ),
                      const SizedBox(width: 10),
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
                ],
              ),
            ),
            /// LANGUAGE BUTTON
            GestureDetector(
              onTap: onLanguageTap,
              child: Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryRed, AppColors.darkRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                ),
                child: const Icon(
                  CupertinoIcons.globe,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        /// 3D MATERIAL BANNER
        GestureDetector(
          onTap: onBannerTap,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
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
