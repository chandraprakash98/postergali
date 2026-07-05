import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';

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

    final usableWidth = width - (horizontalPadding * 2) - centerGap;
    final itemWidth = usableWidth / 4;

    double centerX = 0;
    switch (index) {
      case 0:
        centerX = horizontalPadding + (itemWidth * 0.5);
        break;
      case 1:
        centerX = horizontalPadding + (itemWidth * 1.5);
        break;
      case 2:
        centerX = horizontalPadding + (itemWidth * 2.5) + centerGap;
        break;
      case 3:
        centerX = horizontalPadding + (itemWidth * 3.5) + centerGap;
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

              /// CENTER BUTTON placeholder
              Positioned(
                top: -32,
                left: width / 2 - 39,
                child: Container(
                  width: 78,
                  height: 78,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
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
                          context,
                          0,
                          CupertinoIcons.house_fill,
                          context.tr('home'),
                        ),
                      ),
                      Expanded(
                        child: _item(
                          context,
                          1,
                          CupertinoIcons.location_solid,
                          context.tr('location'),
                        ),
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        child: _item(
                          context,
                          2,
                          CupertinoIcons.heart_fill,
                          context.tr('liked'),
                        ),
                      ),
                      Expanded(
                        child: _item(
                          context,
                          3,
                          CupertinoIcons.doc_text_fill,
                          context.tr('my_poster'),
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
    BuildContext context,
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
                color: selected ? const Color(0xffF2C96B) : const Color(0xffE7C46A),
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
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1,
                shadows: selected
                    ? [
                        Shadow(
                          color: const Color(0xffF2C96B).withOpacity(.8),
                          blurRadius: 18,
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

class _BottomBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xffB5402C)
      ..style = PaintingStyle.fill;

    var path = Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutRadius = 50.0;
    final cutPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width / 2, 0),
          radius: cutRadius,
        ),
      );

    path = Path.combine(PathOperation.difference, path, cutPath);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _StreetLightPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
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
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawPath(path, paint);

    final bulb = Paint()..color = const Color(0xffFFD76B);
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
