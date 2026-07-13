import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class OfferTemplatesFull {
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
        Image.asset(AppAssets.offerImg1, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "KumarOne",
                      color: const Color(0xffF5B32C),
                      fontSize: _getResponsiveSize(context, 34),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Text(
                    (offer['offer_type'] ?? 'SPECIAL OFFER').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Impact",
                      color: Colors.white,
                      fontSize: _getResponsiveSize(context, 40),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Expanded(
                    child: Center(
                      child: Text(
                        (offer['offer_details'] ?? '').toString().toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Qasira",
                          color: const Color(0xff6CF6F2),
                          fontSize: _getResponsiveSize(context, 58),
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "BernardMTCondensed",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 36),
                    ),
                  ),
                  const SizedBox(height: 120),
                  Text(
                    (offer['offer_type'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Impact",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 32),
                    ),
                  ),
                  const SizedBox(height: 80),
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
                          fontSize: _getResponsiveSize(context, 46),
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Quintessential",
                      color: const Color(0xffFFD08A),
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 48),
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
                      fontSize: _getResponsiveSize(context, 52),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    (offer['offer_details'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "TimesNewRoman",
                      color: Colors.white,
                      fontSize: _getResponsiveSize(context, 48),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    (offer['business_name'] ?? '').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "LemonMilk",
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: _getResponsiveSize(context, 28),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    (offer['offer_type'] ?? 'NEW ARRIVALS').toString().toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "ClashDisplay",
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: _getResponsiveSize(context, 52),
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
                      fontSize: _getResponsiveSize(context, 48),
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
      padding: const EdgeInsets.all(28),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 320,
          height: 440,
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
                  fontSize: _getResponsiveSize(context, 34),
                ),
              ),
              const Spacer(),
              Text(
                (offer['offer_details'] ?? '').toString().toUpperCase(),
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "HelveticaNeue",
                  fontWeight: FontWeight.w700,
                  fontSize: _getResponsiveSize(context, 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}