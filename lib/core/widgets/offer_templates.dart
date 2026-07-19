import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class OfferTemplates {
  static double _getResponsiveSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    double scaleFactor = width / 375.0;
    scaleFactor = scaleFactor.clamp(0.85, 1.2);
    return baseSize * scaleFactor;
  }

  static Widget templateT001(dynamic offer, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        Image.asset(
          AppAssets.offerImg1,
          fit: BoxFit.cover,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [

              const SizedBox(height: 28),

              /// Business Name
              Text(
                (offer['business_name'] ?? "")
                    .toString()
                    .toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Qasira",
                  color: Color(0xffF8B624),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 18),

              /// Special Offer
              Text(
                (offer['offer_type'] ?? "SPECIAL OFFER")
                    .toString()
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "Impact",
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Expanded(
                child: Center(
                  child: Text(
                    (offer['offer_details'] ?? "")
                        .toString()
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Impact",
                      color: Color(0xff6CF7F4),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(3, 3),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 22),
            ],
          ),
        ),
      ],
    );
  }
  static Widget templateT002(dynamic offer, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.offerImg2, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 300,
              height: 380,
              child: Column(
                children: [
                  const SizedBox(height: 34),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "BernardMTCondensed",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 24),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    (offer['offer_type'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Impact",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 20),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Expanded(
                    child: Center(
                      child: Text(
                        (offer['offer_details'] ?? '').toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Garamond",
                          color: const Color(0xffFFF04A),
                          fontWeight: FontWeight.w900,
                          fontSize: _getResponsiveSize(context, 28),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget templateT003(dynamic offer, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.offerImg3, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 300,
              height: 380,
              child: Column(
                children: [
                  const SizedBox(height: 34),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Quintessential",
                      color: const Color(0xffFFD08A),
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 32),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    (offer['offer_type'] ?? 'OFFER').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Impact",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 36),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    (offer['offer_details'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                      color: Colors.white,
                      fontSize: _getResponsiveSize(context, 30),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget templateT004(dynamic offer, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.offerImg4, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 300,
              height: 380,
              child: Column(
                children: [
                  const SizedBox(height: 34),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "LemonMilk",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: _getResponsiveSize(context, 20),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    (offer['offer_type'] ?? 'NEW ARRIVALS').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "ClashDisplay",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 32),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    (offer['offer_details'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "MonteStella",
                      color: const Color(0xffFFF04A),
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 30),
                      height: .95,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
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