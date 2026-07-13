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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.830),
              const Color(0xFF179A1E).withOpacity(0.450),
              const Color(0xFF2E7D32).withOpacity(0.950),
            ],
          ),
        ),
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
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 320,
                  height: 440,
                  child: Column(
                    children: [
                      Text(
                        "VACANCY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "KumarOne",
                          fontSize: _getResponsiveSize(context, 60),
                          height: .85,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2E7D32),
                          shadows: const [
                            Shadow(offset: Offset(-3, 0), color: Colors.white),
                            Shadow(offset: Offset(3, 0), color: Colors.white),
                            Shadow(offset: Offset(0, -3), color: Colors.white),
                            Shadow(offset: Offset(0, 3), color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        (job['business_name'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "KumarOne",
                          fontSize: _getResponsiveSize(context, 28),
                          color: const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w800,
                          shadows: const [
                            Shadow(offset: Offset(-3, 0), color: Colors.yellow),
                            Shadow(offset: Offset(3, 0), color: Colors.white),
                            Shadow(offset: Offset(0, -3), color: Colors.white),
                            Shadow(offset: Offset(0, 3), color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Center(
                          child: Text(
                            (job['job_role'] ?? '').toUpperCase(),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Impact",
                              fontSize: _getResponsiveSize(context, 36),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(offset: Offset(-2, 0), color: Colors.black87),
                                Shadow(offset: Offset(2, 0), color: Colors.black87),
                                Shadow(offset: Offset(0, -2), color: Colors.black87),
                                Shadow(offset: Offset(0, 2), color: Colors.black87),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                        style: TextStyle(
                          fontFamily: "LemonMilk",
                          fontSize: _getResponsiveSize(context, 24),
                          color: Colors.black87,
                          shadows: const [
                            Shadow(offset: Offset(-1, 0), color: Colors.white),
                            Shadow(offset: Offset(1, 0), color: Colors.white24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "₹${job['salary'] ?? '25,000'}",
                        style: TextStyle(
                          fontFamily: "ClashDisplay",
                          fontSize: _getResponsiveSize(context, 40),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xfff3f6f0),
                          shadows: const [
                            Shadow(offset: Offset(-2, 0), color: Colors.black87),
                            Shadow(offset: Offset(2, 0), color: Colors.black87),
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
      ),
    );
  }

  static Widget templateT002(dynamic job, BuildContext context) {
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
            Image.asset(
              AppAssets.defaultJobImage,
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.08),
              colorBlendMode: BlendMode.modulate,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 320,
                  height: 440,
                  child: Column(
                    children: [
                      Text(
                        "WE ARE\nHIRING",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: "Qasira",
                          fontSize: _getResponsiveSize(context, 52),
                          height: .85,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        (job['business_name'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "BernardMTCondensed",
                          fontSize: _getResponsiveSize(context, 32),
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
                            style: TextStyle(
                              fontFamily: "Garamond",
                              fontSize: _getResponsiveSize(context, 46),
                              height: .9,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 34,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "₹${job['salary'] ?? '15,000'}",
                          style: TextStyle(
                            fontFamily: "Impact",
                            fontSize: _getResponsiveSize(context, 42),
                            fontWeight: FontWeight.w900,
                            color: const Color(0xffA02AB4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                        style: TextStyle(
                          fontFamily: "LemonMilk",
                          fontSize: _getResponsiveSize(context, 26),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget templateT003(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T003.png'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE8D22D).withOpacity(0.630),
              const Color(0xFFE8D22D).withOpacity(0.850),
              const Color(0xFFE8D22D).withOpacity(0.550),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xff5F0B75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "URGENTLY\nHIRING",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Impact",
                        fontSize: _getResponsiveSize(context, 50),
                        height: .85,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    (job['business_name'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Quintessential",
                      fontSize: _getResponsiveSize(context, 36),
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(offset: Offset(2, 2), color: Colors.black),
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
                        style: TextStyle(
                          fontFamily: "TimesNewRoman",
                          fontSize: _getResponsiveSize(context, 48),
                          height: .85,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          shadows: const [
                            Shadow(offset: Offset(-3, -3), color: Colors.black),
                            Shadow(offset: Offset(3, -3), color: Colors.black),
                            Shadow(offset: Offset(-3, 3), color: Colors.black),
                            Shadow(offset: Offset(3, 3), color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "₹${job['salary'] ?? '20,000'}",
                    style: TextStyle(
                      fontFamily: "Impact",
                      fontSize: _getResponsiveSize(context, 44),
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(offset: Offset(2, 2), color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (job['job_type'] ?? 'PART TIME').toUpperCase(),
                    style: TextStyle(
                      fontFamily: "BernardMTCondensed",
                      fontSize: _getResponsiveSize(context, 26),
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: const [
                        Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget templateT004(dynamic job, BuildContext context) {
    return Container(
      decoration: _bgDecoration('assets/images/T004.png'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA64B2A).withOpacity(0.50),
              const Color(0xFFF3DAAC).withOpacity(0.800),
              const Color(0xFFA64B2A).withOpacity(0.950),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 320,
              height: 440,
              child: Column(
                children: [
                  Transform.rotate(
                    angle: -0.02,
                    child: Text(
                      "WE'RE",
                      style: TextStyle(
                        fontFamily: "ClashDisplay",
                        fontSize: _getResponsiveSize(context, 76),
                        fontWeight: FontWeight.w900,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -0.02,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFE600),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        "HIRING",
                        style: TextStyle(
                          fontFamily: "MonteStella",
                          fontSize: _getResponsiveSize(context, 46),
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    (job['business_name'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "HelveticaNeue",
                      fontSize: _getResponsiveSize(context, 28),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff130217),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: Center(
                      child: Text(
                        (job['job_role'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Qasira",
                          fontSize: _getResponsiveSize(context, 50),
                          height: 0.95,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                    style: TextStyle(
                      fontFamily: "LemonMilk",
                      fontSize: _getResponsiveSize(context, 40),
                      color: const Color(0xff3c3505),
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹${job['salary'] ?? '18,000'}",
                    style: TextStyle(
                      fontFamily: "Impact",
                      fontSize: _getResponsiveSize(context, 32),
                      color: const Color(0xffedebdd),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
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