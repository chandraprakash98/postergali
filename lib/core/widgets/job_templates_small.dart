import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class JobTemplatesSmall {


  static BoxDecoration _bgDecoration(String image) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    );
  }
  static Widget templateT001(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T001.png'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.830), // Primary/Saffron/100
              const Color(0xFF179A1E).withOpacity(0.450), // Secondary/Retro Green/500
              const Color(0xFF2E7D32).withOpacity(0.950), // Primary/Terracotta/700
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: .08,
              child: Image.asset(
                AppAssets.defaultJobImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 36,
              ),
              child: Column(
                children: [
                  const Text(
                    "VACANCY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "KumarOne-Regular",
                      fontSize: 34,
                      height: .85,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2E7D32), // Green text

                      shadows: [
                        // White outline
                        Shadow(offset: Offset(-2, 0), color: Colors.white),
                        Shadow(offset: Offset(2, 0), color: Colors.white),
                        Shadow(offset: Offset(0, -2), color: Colors.white),
                        Shadow(offset: Offset(0, 2), color: Colors.white),
                        Shadow(offset: Offset(-2, -2), color: Colors.white),
                        Shadow(offset: Offset(2, -2), color: Colors.white),
                        Shadow(offset: Offset(-2, 2), color: Colors.white),
                        Shadow(offset: Offset(2, 2), color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    (job['business_name'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "KumarOne-Regular",
                      fontSize: 18,
                      color: Color(0xFF2E7D32), // Green text
                      fontWeight: FontWeight.w800,
                      shadows: [
                        // White outline
                        Shadow(offset: Offset(-2, 0), color: Colors.yellow),
                        Shadow(offset: Offset(2, 0), color: Colors.white),
                        Shadow(offset: Offset(0, -2), color: Colors.white),
                        Shadow(offset: Offset(0, 2), color: Colors.white),
                        Shadow(offset: Offset(-2, -2), color: Colors.white),
                        Shadow(offset: Offset(2, -2), color: Colors.white),
                        Shadow(offset: Offset(-2, 2), color: Colors.white),
                        Shadow(offset: Offset(2, 2), color: Colors.white),
                      ],
                    ),
                  ),


                  const SizedBox(height:22),
                  Expanded(
                    child: Center(
                      child: Text(
                        (job['job_role'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "kumarfont",
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          shadows: [
                            // White outline
                            Shadow(offset: Offset(-1, 0), color: Colors.black87),
                            Shadow(offset: Offset(1, 0), color: Colors.black87),
                            Shadow(offset: Offset(0, -1), color: Colors.black87),
                            Shadow(offset: Offset(0, 1), color: Colors.black87),
                            Shadow(offset: Offset(-1, -1), color: Colors.black87),
                            Shadow(offset: Offset(1, -1), color: Colors.black87),
                            Shadow(offset: Offset(-1, 1), color: Colors.black87),
                            Shadow(offset: Offset(1, 1), color: Colors.black87),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    (job['job_type'] ?? 'FULL TIME'),
                    style: const TextStyle(
                      fontFamily: "LEMONMILK-Bold",
                      fontSize: 16,
                      color: Colors.black87,
                      shadows: [
                        // White outline
                        Shadow(offset: Offset(-1, 0), color: Colors.white),
                        Shadow(offset: Offset(1, 0), color: Colors.white24),
                        Shadow(offset: Offset(0, -1), color: Colors.white),
                        Shadow(offset: Offset(0, 1), color: Colors.white24),
                        Shadow(offset: Offset(-1, -1), color: Colors.white),
                        Shadow(offset: Offset(1, -1), color: Colors.black87),
                        Shadow(offset: Offset(-1, 1), color: Colors.white),
                        Shadow(offset: Offset(1, 1), color: Colors.black87),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    child: Text(
                      "₹${job['salary'] ?? '25,000'}",
                      style: const TextStyle(
                        fontFamily: "ClashDisplay",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfff3f6f0),

                        shadows: [
                          // White outline
                          Shadow(offset: Offset(-1, 0), color: Colors.black87),
                          Shadow(offset: Offset(1, 0), color: Colors.black87),
                          Shadow(offset: Offset(0, -1), color: Colors.black87),
                          Shadow(offset: Offset(0, 1), color: Colors.black87),
                          Shadow(offset: Offset(-1, -1), color: Colors.black87),
                          Shadow(offset: Offset(1, -1), color: Colors.black87),
                          Shadow(offset: Offset(-1, 1), color: Colors.black87),
                          Shadow(offset: Offset(1, 1), color: Colors.black87),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



  static Widget templateT002(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T002.png'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.1),
              Colors.purple.withOpacity(0.60),
              Colors.purpleAccent.withOpacity(0.10),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Opacity(
              opacity: .08,
              child: Image.asset(
                AppAssets.defaultJobImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              child: Column(
                children: [
                  const Text(
                    "WE ARE\nHIRING",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 27,
                      height: .85,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (job['business_name'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        (job['job_role'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          height: .9,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "₹${job['salary'] ?? '15,000'}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xffA02AB4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget templateT003(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T003.png'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8D22D).withOpacity(0.630), // Primary/Saffron/100
              const Color(0xFFE8D22D).withOpacity(0.850), // Secondary/Retro Green/500
              const Color(0xFFE8D22D).withOpacity(0.550), // Primary/Terracotta/700
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xff5F0B75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "URGENTLY\nHIRING",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    height: .85,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                (job['business_name'] ?? '').toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    (job['job_role'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      height: .85,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          offset: Offset(-2, -2),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2, -2),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(-2, 2),
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(2, 2),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Text(
                "₹${job['salary'] ?? '20,000'}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Text(
                (job['job_type'] ?? 'PART TIME').toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget templateT004(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T004.png'),
      child: Container(
        decoration: BoxDecoration(
          // Transparent overlay on background image
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA64B2A).withOpacity(0.50), // Primary/Saffron/100
              const Color(0xFFF3DAAC).withOpacity(0.800), // Secondary/Retro Green/500
              const Color(0xFFA64B2A).withOpacity(0.950), // Primary/Terracotta/700
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            children: [



              Transform.rotate(
                angle: -0.02,
                child: Container(


                  child:  const Text(
                    "WE'RE",
                    style: TextStyle(
                      fontFamily: "ClashDisplay",
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),

              Transform.rotate(
                angle: -0.02,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 27,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFE600),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: const Text(
                    "HIRING",
                    style: TextStyle(
                      fontFamily: "MonteStella_Trial_Rg",
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Text(
                (job['business_name'] ?? '').toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff130217),
                ),
              ),

              const SizedBox(height: 15),
              Expanded(
                child: Center(
                  child: Text(
                    (job['job_role'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 0.95,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,

                    ),
                  ),
                ),
              ),


              Text(
                (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xff3c3505),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "₹${job['salary'] ?? '18,000'}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xffedebdd),
                  fontWeight: FontWeight.w900,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
