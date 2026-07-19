import 'package:flutter/material.dart';
import '../constants/app_assets.dart';

class JobTemplates {
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 320,
            height: 600,
            child: Column(
              children: [
                Text(
                  "Job Vacancy",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "KumarOne",
                    fontSize: _getResponsiveSize(context, 48),
                    height: .97,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF31603D),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  (job['business_name'] ?? '').toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "TimesNewRoman",
                    fontSize: _getResponsiveSize(context, 36),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF31603D),
                    height: 0.9,
                    letterSpacing: 0,
                    shadows: const [
                      Shadow(
                        color: Color(0x33000000),
                        offset: Offset(1.5, 1.5),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: Center(
                    child: Text(
                      (job['job_role'] ?? '').toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "TimesNewRoman",
                        fontSize: _getResponsiveSize(context, 48),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 0.9,
                        letterSpacing: 0,
                        shadows: const [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  (job['job_type'] ?? 'FULL TIME').toString().toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: _getResponsiveSize(context, 44),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF31603D),
                    height: 0.99,
                    letterSpacing: 0,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1.2, 1.2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "₹${job['salary'] ?? '25,000'}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "TimesNewRoman",
                    fontSize: _getResponsiveSize(context, 44),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF31603D),
                    height: 0.30,
                    letterSpacing: 0,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1.2, 1.2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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
            padding: const EdgeInsets.all(15),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 320,
                height: 580,
                child: Stack(
                  children: [
                    /// TOP
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "JOB\nOPENING",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 58),
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

                          const SizedBox(height: 40),

                          Text(
                            (job['business_name'] ?? '').toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 36),
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
                            fontSize: _getResponsiveSize(context, 60),
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: .95,
                            shadows: const [
                              Shadow(
                                color: Color(0x88000000),
                                offset: Offset(0, 3),
                                blurRadius: 2,
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
                      bottom: 15,
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
                              fontSize: _getResponsiveSize(context, 34),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xff4B0D5E),
                              height: .9,
                            ),
                          ),

                          const SizedBox(height: 38),

                          Text(
                            "₹ ${job['salary'] ?? '12,000'}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "BernardMTCondensed",
                              fontSize: _getResponsiveSize(context, 36),
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
        padding: const EdgeInsets.all(15),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 320,
            height: 580,
            child: Stack(
              children: [
                // Top Section
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xff5A1270),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Urgently\nHiring",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "DelaGothicOne",
                          fontSize: _getResponsiveSize(context, 48),
                          color: const Color(0xFFFFF35A),
                          height: .82,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

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
                        fontSize: _getResponsiveSize(context, 38),
                        color: const Color(0xff5A1270),
                        height: .9,
                      ),
                    ),

                    const SizedBox(height: 60),

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
                          fontSize: _getResponsiveSize(context, 64),
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

                // Bottom Section
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
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
                          fontSize: _getResponsiveSize(context, 32),
                          color: const Color(0xff5A1270),
                          height: .9,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "₹${job['salary'] ?? '25,000'}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w900,
                          fontSize: _getResponsiveSize(context, 38),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 320,
            height: 640,
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// WE'RE
                Text(
                  "WE'RE",
                  style: TextStyle(
                    fontFamily: "Impact",
                    fontSize: _getResponsiveSize(context, 55),
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -1,
                    height: 1.0,
                  ),
                ),

                const SizedBox(height: 10),

                /// HIRING
                Transform.rotate(
                  angle: -0.04,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xffFFD700),
                    ),
                    child: Text(
                      "HIRING",
                      style: TextStyle(
                        fontFamily: "Impact",
                        fontSize: _getResponsiveSize(context, 65),
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

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
                          fontFamily: "BernardMTCondensed",
                          fontSize: _getResponsiveSize(context, 52),
                          fontWeight: FontWeight.w500,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3.5
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        (job['business_name'] ?? '').toString(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "BernardMTCondensed",
                          fontSize: _getResponsiveSize(context, 52),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffFFD700),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

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
                        fontSize: _getResponsiveSize(context, 72),
                        height: 0.95,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(3, 3),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// FOOTER
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${(job['job_type'] ?? 'FULL-TIME').toUpperCase()}  ₹${job['salary'] ?? '12,000'}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Impact",
                        fontSize: _getResponsiveSize(context, 42),
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: -0.5,
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
    );
  }

  static Widget defaultTemplate(dynamic job, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff811d1d), Color(0xffF2F2F2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            width: 320,
            height: 440,
            child: Column(
              children: [
                Text(
                  (job['business_name'] ?? '').toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: _getResponsiveSize(context, 34),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      (job['job_role'] ?? '').toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: "HelveticaNeue",
                        fontSize: _getResponsiveSize(context, 28),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Text(
                  "₹${job['salary'] ?? '15,000'}",
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: _getResponsiveSize(context, 32),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                  style: TextStyle(
                    fontFamily: "HelveticaNeue",
                    fontSize: _getResponsiveSize(context, 30),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}