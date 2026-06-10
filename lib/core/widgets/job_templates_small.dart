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
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: .08,
            child: Image.asset(AppAssets.defaultJobImage, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              children: [
                const Text(
                  "JOB\nVACANCY",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    height: .85,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  (job['business_name'] ?? '').toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      (job['job_role'] ?? '').toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 28, height: .9, color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    "₹${job['salary'] ?? '25,000'}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xff7AA933)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget templateT002(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T002.png'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: .08,
            child: Image.asset(AppAssets.defaultJobImage, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Column(
              children: [
                const Text(
                  "WE ARE\nHIRING",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 27, height: .85, color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Text(
                  (job['business_name'] ?? '').toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w900),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      (job['job_role'] ?? '').toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20, height: .9, color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    "₹${job['salary'] ?? '15,000'}",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xffA02AB4)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  (job['job_type'] ?? 'FULL TIME').toUpperCase(),
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget templateT003(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T003.png'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: const Color(0xff5F0B75), borderRadius: BorderRadius.circular(12)),
              child: const Text(
                "URGENTLY\nHIRING",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, height: .85, color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              (job['business_name'] ?? '').toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, color: Color(0xff5F0B75), fontWeight: FontWeight.w800),
            ),
            Expanded(
              child: Center(
                child: Text(
                  (job['job_role'] ?? '').toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, height: .85, color: Color(
                      0xff130217), fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Text(
              "₹${job['salary'] ?? '20,000'}",
              style: const TextStyle(fontSize: 24, color: Color(0xff5F0B75), fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              (job['job_type'] ?? 'PART TIME').toUpperCase(),
              style: const TextStyle(fontSize: 16, color: Color(0xff5F0B75), fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  static Widget templateT004(dynamic job) {
    return Container(
      decoration: _bgDecoration('assets/images/T004.png'),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Column(
          children: [
            const Text(
              "WE'RE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Transform.rotate(
              angle: -0.08, // tilt effect
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffFFE600),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "HIRING",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              (job['business_name'] ?? '').toUpperCase(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xffFFE600),
                shadows: [
                  Shadow(
                    offset: Offset(-1.5, -1.5),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(1.5, -1.5),
                    color: Colors.black,
                  ),
                  Shadow(
                    offset: Offset(-1.5, 1.5),
                    color: Colors.black,
                  ),
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
                    fontSize: 15,
                    height: 0.95,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
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
              (job['job_type'] ?? 'FULL TIME').toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "₹${job['salary'] ?? '18,000'}",
              style: const TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
