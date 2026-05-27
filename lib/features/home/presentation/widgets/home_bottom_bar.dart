  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

import '../../../posterman/bot_splash_screen.dart';
import '../../../posterman/poster_man_chat_screen.dart';

  class HomeBottomBar extends StatelessWidget {
    final int selectedIndex;
    final Function(int) onItemTapped;

    const HomeBottomBar({
      super.key,
      required this.selectedIndex,
      required this.onItemTapped,
    });

    double _spotLeft(int index, double width) {
      const horizontalPadding = 8.0;
      const centerGap = 80.0;
      const spotlightWidth = 105.0;

      final usableWidth =
          width - (horizontalPadding * 2) - centerGap;

      final itemWidth = usableWidth / 4;

      double centerX = 0;

      switch (index) {
        case 0:
          centerX =
              horizontalPadding + (itemWidth * 0.5);
          break;

        case 1:
          centerX =
              horizontalPadding + (itemWidth * 1.5);
          break;

        case 2:
          centerX =
              horizontalPadding +
                  (itemWidth * 2.5) +
                  centerGap;
          break;

        case 3:
          centerX =
              horizontalPadding +
                  (itemWidth * 3.5) +
                  centerGap;
          break;
      }

      return centerX - (spotlightWidth / 2);
    }

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        height: 109,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                /// NAV BAR BACKGROUND
                Positioned(
                  bottom: 0,
                  child: CustomPaint(
                    size: Size(width, 108),
                    painter: _BottomBarPainter(),
                  ),
                ),

                /// MOVING STREET LIGHT
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeInOut,
                  left: _spotLeft(selectedIndex, width),
                  top: -7,
                  child: IgnorePointer(
                    child: SizedBox(
                      width: 105,
                      height: 95,
                      child: CustomPaint(
                        painter: _StreetLightPainter(),
                      ),
                    ),
                  ),
                ),

                /// CENTER BUTTON
                Positioned(
                  top: -32,
                  left: width / 2 - 39,

                  child: GestureDetector(
                    onTap: () {
            },
                    child: Container(
                      width: 78,
                      height: 78,
                      child: const Icon(
                        CupertinoIcons.add,
                        size: 38,
                        color: Color(0xffA53A2E),
                      ),

                    ),
                  ),
                ),

                /// NAV ITEMS
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 6,
                      bottom: 6,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _item(
                            0,
                            CupertinoIcons.house_fill,
                            "Home",
                          ),
                        ),

                        Expanded(
                          child: _item(
                            1,
                            CupertinoIcons.location_solid,
                            "Location",
                          ),
                        ),

                        const SizedBox(width: 80),

                        Expanded(
                          child: _item(
                            2,
                            CupertinoIcons.heart_fill,
                            "Liked",
                          ),
                        ),

                        Expanded(
                          child: _item(
                            3,
                            CupertinoIcons.doc_text_fill,
                            "MyPoster",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    Widget _item(
        int index,
        IconData icon,
        String title,
        ) {
      final selected = selectedIndex == index;

      return GestureDetector(
        onTap: () => onItemTapped(index),
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: selected ? 1.08 : 1,
                child: Icon(
                  icon,
                  size: 29,
                  color: const Color(0xffF3C35D),
                  shadows: selected
                      ? [
                    Shadow(
                      color: Colors.orange.withOpacity(.9),
                      blurRadius: 20,
                    ),
                  ]
                      : [],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                title,
                style: TextStyle(
                  color: const Color(0xffF3C35D),
                  fontSize: 12.8,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  shadows: selected
                      ? [
                    Shadow(
                      color: Colors.orange.withOpacity(.9),
                      blurRadius: 20,
                    ),
                  ]
                      : [],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// NAV BAR SHAPE
  class _BottomBarPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final paint = Paint()
        ..color = const Color(0xffA53A2E)
        ..style = PaintingStyle.fill;

      var path = Path();

      // MAIN BAR
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

      // CENTER CUT (REAL MASK FIX)
      final cutRadius = 46.0;

      final cutPath = Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, 0),
            radius: cutRadius,
          ),
        );

      // THIS IS KEY (removes background properly)
      path = Path.combine(PathOperation.difference, path, cutPath);

      canvas.drawShadow(
        path,
        Colors.black.withOpacity(0.25),
        12,
        false,
      );

      canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) => false;
  }
  /// STREET LIGHT EFFECT
  class _StreetLightPainter extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
      final path = Path();

      /// WIDER SPOTLIGHT
      path.moveTo(size.width * .30, 10);

      path.lineTo(size.width * .70, 10);

      path.lineTo(size.width * .98, size.height);

      path.lineTo(size.width * .02, size.height);

      path.close();

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xfff4f4f1).withOpacity(.95),
            const Color(0xffFFD76B).withOpacity(.65),
            const Color(0xffFFD76B).withOpacity(.18),
            Colors.transparent,
          ],
          stops: const [0, .25, .65, 1],
        ).createShader(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
        );

      canvas.drawPath(path, paint);

      /// LIGHT SOURCE
      final bulb = Paint()
        ..color = const Color(0xffFFD76B);

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, 8),
            width: 36,
            height: 6,
          ),
          const Radius.circular(30),
        ),
        bulb,
      );
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  }