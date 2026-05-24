import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class HomeBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const HomeBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryRed.withOpacity(.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -38,
            child: Container(
              width: 103,
              height: 85,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                index: 0,
                icon: CupertinoIcons.house_fill,
                title: "Home",
              ),
              _navItem(
                index: 1,
                icon: CupertinoIcons.location_fill,
                title: "Location",
              ),
              const SizedBox(width: 70),
              _navItem(
                index: 2,
                icon: CupertinoIcons.heart_fill,
                title: "Liked",
              ),
              _navItem(
                index: 3,
                icon: CupertinoIcons.doc_text_fill,
                title: "MyPoster",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 4,
              width: isSelected ? 28 : 0,
              decoration: BoxDecoration(
                color: AppColors.golden,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(.7),
              size: 25,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                color: isSelected ? Colors.white : Colors.white.withOpacity(.7),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
