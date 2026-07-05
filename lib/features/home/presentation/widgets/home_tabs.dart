import 'package:flutter/material.dart';

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
      height: 70,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: const Color(0xffB5402C),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onJobsTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: selectedTab == 0
                      ? const Color(0xffEFE2C9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: selectedTab == 0
                      ? [
                    BoxShadow(
                      color: const Color(0xffFFB08C).withOpacity(.7),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Jobs",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: selectedTab == 0
                        ? const Color(0xffB5402C)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: onOffersTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: selectedTab == 1
                      ? const Color(0xffEFE2C9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: selectedTab == 1
                      ? [
                    BoxShadow(
                      color: const Color(0xffFFB08C).withOpacity(.7),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Offers",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: selectedTab == 1
                        ? const Color(0xffB5402C)
                        : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}