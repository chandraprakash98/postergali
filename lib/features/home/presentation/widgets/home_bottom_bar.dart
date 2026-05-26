import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const HomeBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  double _spotLeft(int index, double width) {
    final itemWidth = width / 5;
    // 5 slots: Home | Location | (center gap) | Liked | MyPoster

    final actualIndexMap = [0, 1, 3, 4];

    final slot = actualIndexMap[index];
    final centerOfItem = (slot * itemWidth) + (itemWidth / 2);

    return centerOfItem - 39;
    // 39 = half of spotlight width (78/2)
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              /// NAV BAR SHAPE
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
                left: _spotLeft(
                  selectedIndex,
                  width,
                ),
                top: 1,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 98,
                    height: 91,
                    child: CustomPaint(
                      painter: _StreetLightPainter(),
                    ),
                  ),
                ),
              ),

              /// CENTER BUTTON
              /// CENTER BUTTON (SINGLE CLEAN CIRCLE)
              Positioned(
                top: -32,
                left: width / 2 - 40,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffF3C35D),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
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
                      Expanded(child: _item(0, CupertinoIcons.house_fill, "Home")),
                      Expanded(child: _item(1, CupertinoIcons.location_solid, "Location")),

                      const SizedBox(width: 80), // center space (match button)

                      Expanded(child: _item(2, CupertinoIcons.heart_fill, "Liked")),
                      Expanded(child: _item(3, CupertinoIcons.doc_text_fill, "MyPoster")),
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
              duration:
              const Duration(milliseconds: 250),
              scale: selected ? 1.08 : 1,
              child: Icon(
                icon,
                size: 29,
                color: const Color(0xffF3C35D),
                shadows: selected
                    ? [
                  Shadow(
                    color: Colors.orange
                        .withOpacity(.65),
                    blurRadius: 12,
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
                    color: Colors.orange
                        .withOpacity(.7),
                    blurRadius: 12,
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

/// PERFECT CURVED SHAPE
class _BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffA53A2E)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(0, 0);

    /// LEFT SMOOTH
    path.quadraticBezierTo(
      size.width * .18,
      0,
      size.width * .30,
      0,
    );

    /// CENTER CURVE
    path.lineTo(size.width * .36, 0);

    path.cubicTo(
      size.width * .40,
      0,
      size.width * .42,
      28,
      size.width * .46,
      34,
    );

    path.quadraticBezierTo(
      size.width * .50,
      40,
      size.width * .54,
      34,
    );

    path.cubicTo(
      size.width * .58,
      28,
      size.width * .60,
      0,
      size.width * .64,
      0,
    );

    /// RIGHT SMOOTH
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    canvas.drawShadow(
      path,
      Colors.black.withOpacity(.25),
      10,
      false,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

/// STREET LIGHT EFFECT
class _StreetLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    /// START LITTLE DOWN
    path.moveTo(size.width * .38, 10);

    path.lineTo(size.width * .62, 10);

    path.lineTo(size.width * .88, size.height);

    path.lineTo(size.width * .12, size.height);

    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xffFFD76B).withOpacity(.95),
          const Color(0xffFFD76B).withOpacity(.45),
          const Color(0xffFFD76B).withOpacity(.12),
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
          width: 32,
          height: 5,
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