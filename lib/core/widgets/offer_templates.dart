import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class OfferTemplates {
  static double _getResponsiveSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    double scaleFactor = width / 375.0;
    scaleFactor = scaleFactor.clamp(0.85, 1.2);
    return baseSize * scaleFactor;
  }
  static Widget templateT001(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 340).clamp(0.70, 1.25);

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
              padding: EdgeInsets.symmetric(horizontal: 18 * scale),
              child: Stack(
                children: [

                  const SizedBox(height: 34),
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 48 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 27,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Qasira",
                        color: const Color(0xffF8B624),
                        fontSize: 34 * scale,
                        fontWeight: FontWeight.bold,
                        height: .85,
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 135 * scale,
                    left: 5 * scale,
                    right: 5 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "SPECIAL OFFER")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 28 * scale,
                        fontWeight: FontWeight.w700,
                        height: .90,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(3, 3),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 12 * scale,
                    right: 12 * scale,
                    bottom: 30 * scale,
                    top: 205 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 8,
                        minFontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: const Color(0xff6CF7F4),
                          fontSize: 18 * scale,
                          height: .90,
                          shadows: const [
                            Shadow(
                              color: const Color(0xfff8a102),
                              offset: Offset(1, 1),
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
        final scale = (constraints.maxWidth / 340).clamp(0.70, 1.25);

        return Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.offerImg2,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top:  48* scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 18,
                      style: TextStyle(
                        fontFamily: "Paytoneone",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 30 * scale,
                        height: .88,
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

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 165 * scale,
                    left: 10 * scale,
                    right: 10 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 22,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 46* scale,
                        height: .98,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(3, 3),
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
                    top: 270 * scale,
                    bottom: 24 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        minFontSize: 19,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: const Color(0xffFFED57),
                          fontSize: 19 * scale,
                          height: .99,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
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




  static Widget templateT003(dynamic offer, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / 340).clamp(0.70, 1.25);

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
              padding: EdgeInsets.symmetric(horizontal: 20 * scale),
              child: Stack(
                children: [
                  /// ================= BUSINESS NAME =================
                  Positioned(
                    top: 28 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['business_name'] ?? "").toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 19,
                      style: TextStyle(
                        fontFamily: "Quintessential",
                        color: Colors.white,
                        fontSize: 35 * scale,
                        height: 0.90,
                        fontWeight: FontWeight.w400,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 145 * scale,
                    left: 0,
                    right: 0,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "OFFER")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 22,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 48 * scale,
                        height: .90,
                        fontWeight: FontWeight.w700,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(3, 3),
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),

                  /// ================= DESCRIPTION =================
                  Positioned(
                    left: 18 * scale,
                    right: 18 * scale,
                    top: 235 * scale,
                    bottom: 25 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString(),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        minFontSize: 14,
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          color: Colors.white,
                          fontSize: 28 * scale,
                          height: .90,
                          fontWeight: FontWeight.w400,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(2, 2),
                              blurRadius: 2,
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
        final scale = (constraints.maxWidth / 340).clamp(0.70, 1.25);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// Background
            Image.asset(
              AppAssets.offerImg4,
              fit: BoxFit.cover,
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18 * scale),
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
                      minFontSize: 16,
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        color: Colors.white,
                        fontSize: 42 * scale,
                        fontWeight: FontWeight.bold,
                        height: .85,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ================= OFFER TITLE =================
                  Positioned(
                    top: 155 * scale,
                    left: 5 * scale,
                    right: 5 * scale,
                    child: AutoSizeText(
                      (offer['offer_type'] ?? "NEW ARRIVALS")
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      minFontSize: 18,
                      style: TextStyle(
                        fontFamily: "Impact",
                        color: Colors.white,
                        fontSize: 51 * scale,
                        fontWeight: FontWeight.w900,
                        height: .94,
                        shadows: const [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(3, 3),
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
                    top: 280 * scale,
                    bottom: 25 * scale,
                    child: Center(
                      child: AutoSizeText(
                        (offer['offer_details'] ?? "").toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 8,
                        minFontSize: 14,
                        style: TextStyle(
                          fontFamily: "BebasNeue",
                          color: const Color(0xffFFE84A),
                          fontSize: 34 * scale,
                          fontWeight: FontWeight.bold,

                          letterSpacing: 1,
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
  static Widget defaultTemplate(dynamic offer, BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 300,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (offer['business_name'] ?? '').toString().toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "HelveticaNeue",
                  fontWeight: FontWeight.w900,
                  fontSize: _getResponsiveSize(context, 26),
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Text(
                (offer['offer_details'] ?? '').toString().toUpperCase(),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "HelveticaNeue",
                  fontWeight: FontWeight.w700,
                  fontSize: _getResponsiveSize(context, 22),
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}