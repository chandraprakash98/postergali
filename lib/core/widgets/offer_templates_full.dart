import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_assets.dart';

class OfferTemplatesFull {
  static Widget templateT001(dynamic offer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            AppAssets.offerImg1,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              Text(
                (offer['business_name'] ?? '').toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.yesevaOne(
                  color: const Color(0xffF5B32C),
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 50),

              const Text(
                "SPECIAL OFFER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: Center(
                  child: Text(
                    (offer['offer_details'] ?? '')
                        .toString()
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff6CF6F2),
                      fontSize: 45,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -2,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(2, 4),
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
  }

  static Widget templateT002(dynamic offer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            AppAssets.offerImg2,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              Text(
                offer['business_name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_type'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 43,
                  height: .86,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_details'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffFFF04A),
                  fontWeight: FontWeight.w900,
                  fontSize: 42,
                  height: 1,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  static Widget templateT003(dynamic offer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            AppAssets.offerImg3,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            children: [
              Text(
                offer['business_name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffFFD08A),
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),

              const Spacer(),

              const Text(
                "GRAND\nOPENING\nOFFER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 52,
                  height: .9,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_details'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontStyle: FontStyle.italic,
                  height: 1,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  static Widget templateT004(dynamic offer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            AppAssets.offerImg4,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: Column(
            children: [
              Text(
                offer['business_name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "NEW ARRIVALS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 52,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_details'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xffFFF04A),
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                  height: 1,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  static Widget defaultTemplate(dynamic offer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            offer['business_name'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 34,
            ),
          ),

          const Spacer(),

          Text(
            offer['offer_details'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}