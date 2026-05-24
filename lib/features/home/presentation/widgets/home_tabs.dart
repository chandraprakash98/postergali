import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeTabs extends StatelessWidget {
  final int selectedTab;
  final VoidCallback onJobsTap;
  final VoidCallback onOffersTap;

  const HomeTabs({
    super.key,
    required this.selectedTab,
    required this.onJobsTap,
    required this.onOffersTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabItem(
            title: "Jobs",
            isSelected: selectedTab == 0,
            onTap: onJobsTap,
          ),
          const SizedBox(width: 8),
          _buildTabItem(
            title: "Offers",
            isSelected: selectedTab == 1,
            onTap: onOffersTap,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primaryRed, AppColors.darkRed],
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'ClashDisplay',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
