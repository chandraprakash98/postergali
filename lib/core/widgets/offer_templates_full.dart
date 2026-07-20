import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../constants/app_assets.dart';

class OfferTemplatesFull {
  static double _getResponsiveSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    double scaleFactor = width / 375.0;
    scaleFactor = scaleFactor.clamp(0.85, 1.2);
    return baseSize * scaleFactor;
  }

  static Widget templateT001(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 320).clamp(0.8, 2.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Background
            Image.asset(
              AppAssets.offerImg1,
              fit: BoxFit.cover,
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 60 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 30,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Qasira",
                        color: const Color(0xffF8B624),
                        fontSize: 48 * scale,
                        fontWeight: FontWeight.bold,
                        height: .85,
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 180 * scale,
                    left: 5 * scale,
                    right: 5 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "SPECIAL OFFER")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 42 * scale,
                        fontWeight: FontWeight.w700,
                        height: .90,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(4, 4),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 12 * scale,
                    right: 12 * scale,
                    bottom: 40 * scale,
                    top: 300 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 8,
                        minFontSize: 22,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: const Color(0xff6CF7F4),
                          fontSize: 28 * scale,
                          height: .90,
                          shadows: const [
                            Shadow(
                              color: const Color(0xfff8a102),
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget templateT002(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 320).clamp(0.8, 2.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.offerImg2,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 65 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 24,
                      style: TextStyle(
                        fontFamily: "Paytoneone",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 42 * scale,
                        height: .88,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(3, 3),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 230 * scale,
                    left: 10 * scale,
                    right: 10 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 28,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 58 * scale,
                        height: .98,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(4, 4),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 12 * scale,
                    right: 12 * scale,
                    top: 380 * scale,
                    bottom: 30 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        minFontSize: 24,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: const Color(0xffFFED57),
                          fontSize: 30 * scale,
                          height: .99,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget templateT003(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 320).clamp(0.8, 2.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Background
            Image.asset(
              AppAssets.offerImg3,
              fit: BoxFit.cover,
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 40 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 28,
                      style: TextStyle(
                        fontFamily: "Quintessential",
                        color: Colors.white,
                        fontSize: 52 * scale,
                        height: 0.90,
                        fontWeight: FontWeight.w400,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(3, 3),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 200 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "OFFER")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 30,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 68 * scale,
                        height: .90,
                        fontWeight: FontWeight.w700,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(4, 4),
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 18 * scale,
                    right: 18 * scale,
                    top: 320 * scale,
                    bottom: 35 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        minFontSize: 20,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: Colors.white,
                          fontSize: 42 * scale,
                          height: .90,
                          fontWeight: FontWeight.w400,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                              blurRadius: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget templateT004(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 320).clamp(0.8, 2.0);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Background
            Image.asset(
              AppAssets.offerImg4,
              fit: BoxFit.fill,
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 55 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 22,
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        color: Colors.white,
                        fontSize: 44 * scale,
                        fontWeight: FontWeight.bold,
                        height: .85,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(3, 3),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 180 * scale,
                    left: 5 * scale,
                    right: 5 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "NEW ARRIVALS")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 26,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 70 * scale,
                        fontWeight: FontWeight.w900,
                        height: .94,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(4, 4),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 12 * scale,
                    right: 12 * scale,
                    top: 310 * scale,
                    bottom: 35 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        minFontSize: 18,
                        style: TextStyle(
                          fontFamily: "BebasNeue",
                          color: const Color(0xffFFE84A),
                          fontSize: 26 * scale,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(3, 3),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget defaultTemplate(dynamic offer, BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            (offer['business_name'] ?? '').toString().toUpperCase(),
            maxLines: 2,
            minFontSize: 24,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "HelveticaNeue",
              fontWeight: FontWeight.w900,
              fontSize: _getResponsiveSize(context, 40),
              color: Colors.black,
            ),
          ),
          const Spacer(),
          AutoSizeText(
            (offer['offer_details'] ?? '').toString().toUpperCase(),
            maxLines: 8,
            minFontSize: 20,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "HelveticaNeue",
              fontWeight: FontWeight.w700,
              fontSize: _getResponsiveSize(context, 34),
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
