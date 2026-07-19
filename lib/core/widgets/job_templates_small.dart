import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class JobTemplatesSmall {
  static double _getResponsiveSize(BuildContext context, double baseSize) {
    double width = MediaQuery.of(context).size.width;
    double scaleFactor = width / 375.0;
    scaleFactor = scaleFactor.clamp(0.85, 1.2);
    return baseSize * scaleFactor;
  }

  static BoxDecoration _bgDecoration(String image) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    );
  }

  static Widget templateT001(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T001.png'),
      child: Stack(
        fit: StackFit.expand,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 300,
                height: 430,
                child: Column(
                  children: [
                    Text(
                      "Job Vacancy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "KumarOne1",
                        fontSize: _getResponsiveSize(context, 44),
                        height: .97,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF31603D),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      (job['business_name'] ?? ''),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        fontSize: _getResponsiveSize(context, 33),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF31603D),
                        height: 0.9,
                        letterSpacing: 0,
                        shadows: const [
                          Shadow(
                            color: const Color(0xFF31603D),
                            offset: Offset(1.2, 1.2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    Expanded(
                      child: Center(
                        child: Text(
                          (job['job_role'] ?? '').toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "TimesNewRoman",
                            fontSize: _getResponsiveSize(context, 44),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 0.9,
                            letterSpacing: 0,
                            shadows: const [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(1.2, 1.2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Text(
                      (job['job_type'] ?? 'FULL TIME').toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'TimesNewRoman',
                        fontSize: _getResponsiveSize(context, 40), // 48px
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF31603D),
                        height: 0.99, // 90% line height
                        letterSpacing: 0,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1.2, 1.2), // slight outline effect
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      "₹${job['salary'] ?? '25,000'}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        fontSize: _getResponsiveSize(context, 40),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF31603D),
                        height: 0.30,
                        letterSpacing: 0,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1.2, 1.2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget templateT002(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T002.png'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.defaultJobImage,
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.08),
            colorBlendMode: BlendMode.modulate,
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 300,
                height: 560,
                child: Stack(
                  children: [
                    /// TOP
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            "JOB\nOPENING",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 54),
                              color: const Color(0xffFFF7EA),
                              fontWeight: FontWeight.w900,
                              height: .99,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 36),

                          Text(
                            (job['business_name'] ?? ''),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 33),
                              color: const Color(0xff4B0D5E),
                              fontWeight: FontWeight.w900,
                              height: .9,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// CENTER JOB ROLE
                    Align(
                      alignment: const Alignment(0, 0.18),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          (job['job_role'] ?? '')
                              .toString()
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: "BernardMTCondensed",
                            fontSize: _getResponsiveSize(context, 54),
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: .95,
                            shadows: const [
                              Shadow(
                                color: Color(0x88000000),
                                offset: Offset(0, 3),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// BOTTOM
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (job['job_type'] ?? 'FULL-TIME')
                                .toString()
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 30),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff4B0D5E),
                              height: .9,
                            ),
                          ),

                          const SizedBox(height: 34),

                          Text(
                            "₹ ${job['salary'] ?? '12,000'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 32),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff4B0D5E),
                              height: .9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget templateT003(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T003.png'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 300,
            height: 560,
            child: Stack(
              children: [
                // Top Section
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xff5A1270),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        "Urgently\nHiring",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "DelaGothicOne",
                          fontSize: _getResponsiveSize(context, 42),
                          color: const Color(0xFFFFF35A),
                          height: .82,
                        ),
                      ),
                    ),

                    const SizedBox(height: 44),

                    Text(
                      (job['business_name'] ?? '')
                          .toString()
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w900,
                        fontSize: _getResponsiveSize(context, 34),
                        color: const Color(0xff5A1270),
                        height: .9,
                      ),
                    ),

                    const SizedBox(height: 54),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        (job['job_role'] ?? '')
                            .toString()
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Impact",
                          fontSize: _getResponsiveSize(context, 58),
                          color: Colors.white,
                          height: .90,
                          letterSpacing: -.5,
                          shadows: const [
                            Shadow(
                              color: Color(0x99000000),
                              offset: Offset(0, 4),
                              blurRadius: 0,
                            ),
                            Shadow(
                              color: Color(0x55000000),
                              offset: Offset(0, 8),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Section (Always Fixed)
                Positioned(

                  left: 0,
                  right: 0,
                  bottom: -0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (job['job_type'] ?? 'PART-TIME')
                            .toString()
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w900,
                          fontSize: _getResponsiveSize(context, 28),
                          color: const Color(0xff5A1270),
                          height: .9,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "₹${job['salary'] ?? '25,000'}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w900,
                          fontSize: _getResponsiveSize(context, 34),
                          color: const Color(0xff5A1270),
                          height: .9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget templateT004(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T004.png'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 19),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 320,
            height: 560,
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// WE'RE
                Text(
                  "WE'RE",
                  style: TextStyle(
                    fontFamily: "DelaGothicOne",
                    fontSize: _getResponsiveSize(context, 48),
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 2,
                    height: 0.9,
                  ),
                ),

                const SizedBox(height: 10),

                /// HIRING
                Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    width: 350,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    color: const Color(0xffF1DB00),
                    child: Text(
                      "HIRING",
                      style: TextStyle(
                        fontFamily: "DelaGothicOne",
                        fontSize: _getResponsiveSize(context, 50),
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 0.95,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                /// BUSINESS NAME
                SizedBox(
                  width: 290,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        (job['business_name'] ?? '').toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "MonteStella_Trial_Rg",
                          fontSize: _getResponsiveSize(context, 40),
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        (job['business_name'] ?? '').toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "MonteStella_Trial_Rg",
                          fontSize: _getResponsiveSize(context, 40),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xffF1DB00),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// JOB ROLE
                Expanded(
                  child: Center(
                    child: Text(
                      (job['job_role'] ?? '').toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "Impact",
                        fontSize: _getResponsiveSize(context, 76),
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 0.9,
                        letterSpacing: 0.1,
                        shadows: const [
                          Shadow(
                            color: Color(0x80000000), // 50% black
                            offset: Offset(1, 2),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// FOOTER
                Text(
                  "${(job['job_type'] ?? 'FULL-TIME').toUpperCase()}   ₹${job['salary'] ?? '12,000'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "MonteStella_Trial_Rg",
                    fontSize: _getResponsiveSize(context, 29),
                    color: Colors.black,
                    letterSpacing: 0,
                  ),
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
