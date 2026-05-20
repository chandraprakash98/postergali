import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferTemplates {

  /// =====================================================
  /// T001
  /// =====================================================

  static Widget templateT001(dynamic offer) {

    return Stack(

      fit: StackFit.expand,

      children: [

        /// BACKGROUND

        Image.asset(
          "assets/images/img_1.png",
          fit: BoxFit.cover,
        ),

        /// CONTENT

        Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.center,

            children: [

              /// TOP SPACE

              const SizedBox(height: 30),

              /// BUSINESS NAME

              Align(

                alignment: Alignment.center,

                child: Padding(

                  padding: const EdgeInsets.only(
                    left: 2,
                  ),

                  child: Text(
                    (offer['business_name'] ?? '')
                        .toString(),

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.yesevaOne(
                      color: const Color(0xffF5B32C),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /// SPECIAL OFFER

              const Text(
                "SPECIAL OFFER",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: -.5,
                ),
              ),

              const SizedBox(height: 14),

              /// BIG OFFER TEXT

              Expanded(

                child: Align(

                  alignment: Alignment.topCenter,

                  child: FittedBox(

                    fit: BoxFit.scaleDown,

                    child: ConstrainedBox(

                      constraints:
                      const BoxConstraints(
                        maxWidth: 210,
                      ),

                      child: Text(
                        (offer['offer_details'] ?? '')
                            .toString()
                            .toUpperCase(),

                        textAlign: TextAlign.center,

                        softWrap: true,

                        overflow:
                        TextOverflow.visible,

                        style: const TextStyle(
                          color: Color(0xff6CF6F2),
                          fontSize: 40,
                          fontWeight: FontWeight.w900,

                          /// SPACE BETWEEN NEW LINES
                          height: 1.08,

                          /// SPACE BETWEEN LETTERS
                          letterSpacing: -1.5,

                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
  /// =====================================================
  /// T002
  /// =====================================================

  static Widget templateT002(dynamic offer) {

    return Stack(

      fit: StackFit.expand,

      children: [

        /// BACKGROUND

        Image.asset(
          "assets/images/img_2.png",
          fit: BoxFit.cover,
        ),

        /// CONTENT

        Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),

          child: Column(

            children: [

              Text(
                offer['business_name'] ?? '',

                textAlign: TextAlign.center,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const Spacer(),

              const FittedBox(

                fit: BoxFit.scaleDown,

                child: Text(
                  "SALE\nSALE\nSALE",

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 40,
                    height: .86,
                    letterSpacing: -1,
                  ),
                ),
              ),

              const Spacer(),

              Padding(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 8,
                ),

                child: Text(
                  offer['offer_details'] ?? '',

                  textAlign: TextAlign.center,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Color(0xffFFF04A),
                    fontWeight: FontWeight.w900,
                    fontSize: 19,
                    height: 1.01,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// T003
  /// =====================================================

  static Widget templateT003(dynamic offer) {

    return Stack(

      fit: StackFit.expand,

      children: [

        /// BACKGROUND

        Image.asset(
          "assets/images/img_3.png",
          fit: BoxFit.cover,
        ),

        /// CONTENT

        Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 22,
          ),

          child: Column(

            children: [

              Text(
                offer['business_name'] ?? '',

                textAlign: TextAlign.center,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Color(0xffFFD08A),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  height: .95,
                ),
              ),

              const Spacer(),

              const Text(
                "GRAND\nOPENING\nOFFER",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  height: .88,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_details'] ?? '',

                textAlign: TextAlign.center,

                maxLines: 3,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  height: 1,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// T004
  /// =====================================================

  static Widget templateT004(dynamic offer) {

    return Stack(

      fit: StackFit.expand,

      children: [

        /// BACKGROUND

        Image.asset(
          "assets/images/img_4.png",
          fit: BoxFit.cover,
        ),

        /// CONTENT

        Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 22,
          ),

          child: Column(

            children: [

              Text(
                offer['business_name'] ?? '',

                textAlign: TextAlign.center,

                maxLines: 2,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "NEW ARRIVALS",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
              ),

              const Spacer(),

              Text(
                offer['offer_details'] ?? '',

                textAlign: TextAlign.center,

                maxLines: 4,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  color: Color(0xffFFF04A),
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  height: .95,
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// DEFAULT
  /// =====================================================

  static Widget defaultTemplate(dynamic offer) {

    return Container(

      color: Colors.white,

      padding: const EdgeInsets.all(16),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(
            offer['business_name'] ?? '',

            maxLines: 2,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22,
            ),
          ),

          const Spacer(),

          Text(
            offer['offer_details'] ?? '',

            maxLines: 4,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}