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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFA2D357).withOpacity(0.950),
              const Color(0xFFA2D357).withOpacity(0.780),
              const Color(0xFFA2D357).withOpacity(0.950),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.defaultJobImage,
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.09),
              colorBlendMode: BlendMode.modulate,
            ),
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
                          fontFamily: "KumarOne",
                          fontSize: _getResponsiveSize(context, 47),
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
                          fontSize: _getResponsiveSize(context, 40),
                          color: const Color(0xFF31603D),
                          fontWeight: FontWeight.w900,
                          height: 0.85,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Center(
                          child: Text(
                            (job['job_role'] ?? ''),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "TimesNewRoman",
                              fontSize: _getResponsiveSize(context, 45),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        (job['job_type'] ?? 'FULL TIME'),
                        style: TextStyle(
                          fontFamily: "TimesNewRoman",
                          fontSize: _getResponsiveSize(context, 30),
                          color: const Color(0xFF31603D),

                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "₹${job['salary'] ?? '25,000'}",
                        style: TextStyle(
                          fontFamily: "ClashDisplay",
                          fontSize: _getResponsiveSize(context, 28),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xfff3f6f0),
                          shadows: const [
                            Shadow(offset: Offset(-1.5, 0), color: Colors.black87),
                            Shadow(offset: Offset(1.5, 0), color: Colors.black87),
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
              Colors.white70.withOpacity(0.1),
              Colors.white70.withOpacity(0.60),
              Colors.white70.withOpacity(0.10),
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
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 300,
                  height: 380,
                  child: Column(
                    children: [
                      Text(
                        "WE ARE\nHIRING",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: "Qasira",
                          fontSize: _getResponsiveSize(context, 40),
                          height: .85,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        (job['business_name'] ?? '').toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "BernardMTCondensed",
                          fontSize: _getResponsiveSize(context, 24),
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
                              fontSize: _getResponsiveSize(context, 32),
                              height: .9,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "₹${job['salary'] ?? '15,000'}",
                          style: TextStyle(
                            fontFamily: "Impact",
                            fontSize: _getResponsiveSize(context, 28),
                            fontWeight: FontWeight.w900,
                            color: const Color(0xffA02AB4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                        style: TextStyle(
                          fontFamily: "LemonMilk",
                          fontSize: _getResponsiveSize(context, 18),
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
          padding: const EdgeInsets.all(12.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: 300,
              height: 400,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff5F0B75),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      "URGENTLY\nHIRING",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Impact",
                        fontSize: _getResponsiveSize(context, 32),
                        height: .85,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    (job['business_name'] ?? '').toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Quintessential",
                      fontSize: _getResponsiveSize(context, 22),
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: const [
                        Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
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
                          fontSize: _getResponsiveSize(context, 28),
                          height: .85,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          shadows: const [
                            Shadow(offset: Offset(-2, -2), color: Colors.black),
                            Shadow(offset: Offset(2, -2), color: Colors.black),
                            Shadow(offset: Offset(-2, 2), color: Colors.black),
                            Shadow(offset: Offset(2, 2), color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "₹${job['salary'] ?? '20,000'}",
                    style: TextStyle(
                      fontFamily: "Impact",
                      fontSize: _getResponsiveSize(context, 30),
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(offset: Offset(1.5, 1.5), color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (job['job_type'] ?? 'PART TIME').toUpperCase(),
                    style: TextStyle(
                      fontFamily: "BernardMTCondensed",
                      fontSize: _getResponsiveSize(context, 20),
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: const [
                        Shadow(offset: Offset(1, 1), color: Colors.black),
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
              const Color(0xFFE8D9CA).withOpacity(0.83),
              const Color(0xFFECE3DB).withOpacity(0.35),
              const Color(0xFFF8F2ED).withOpacity(0.75),
            ],
          ),
        ),
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
                      fontFamily: "ClashDisplay",
                      fontSize: _getResponsiveSize(context, 65),
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
                      width: 250,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      color: const Color(0xffFFD700),
                      child: Text(
                        "HIRING",
                        style: TextStyle(
                          fontFamily: "ClashDisplay",
                          fontSize: _getResponsiveSize(context, 55),
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
                            fontFamily: "MonteStella_Trial_Rg.ttf",
                            fontSize: _getResponsiveSize(context, 40),
                            fontWeight: FontWeight.w900,
                            color: const Color(0xffFFD700),
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
                          fontSize: _getResponsiveSize(context, 68),
                          height: 0.92,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.40),
                              offset: const Offset(2, 2),
                              blurRadius: 2,
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
      ),
    );
  }


}
