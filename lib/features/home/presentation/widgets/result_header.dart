import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import '../../../../core/constants/app_colors.dart';

class ResultHeader extends StatelessWidget {
  final int selectedTab;
  final int resultsCount;
  final VoidCallback onFilterTap;
  final bool isLikedMode;

  const ResultHeader({
    super.key,
    required this.selectedTab,
    required this.resultsCount,
    required this.onFilterTap,
    this.isLikedMode = false,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    if (isLikedMode) {
      title = selectedTab == 0 ? context.tr('liked_jobs') : context.tr('liked_offers');
    } else {
      title = selectedTab == 0 ? context.tr('jobs') : context.tr('offers');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "$resultsCount ${context.tr('results_found')}",
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark.withOpacity(.55),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onFilterTap,
          child: Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: AppColors.primaryRed,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
