import 'package:flutter/material.dart';

class JobTemplates {

  /// =========================================================
  /// TEMPLATE T001
  /// =========================================================

  static Widget templateT001(dynamic job) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffB7D57A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ClipRRect(

        child: Stack(
          fit: StackFit.expand,
          children: [

            /// PAPER TEXTURE
            Opacity(
              opacity: .14,
              child: Image.asset(
                "assets/images/img.png",
                fit: BoxFit.cover,
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),

              child: Column(
                children: [

                  /// TOP SPACE
                  const SizedBox(height: 4),

                  /// JOB VACANCY
                  const Text(
                    "JOB\nVACANCY",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      height: .82,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// COMPANY NAME
                  Text(
                    job['business_name'] ??
                        '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w500,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 10),
                  /// ROLE
                  Text(
                    (job['job_role'] ?? '')
                        .replaceAll(
                      ' ',
                      '\n',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 26,
                      height: .95,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w600,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// JOB TYPE
                  Text(
                    job['job_type'] ??
                        'Part-Time',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w700,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// SALARY
                  Text(
                    "₹${job['salary'] ?? '25,000'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w800,
                      fontFamily: 'serif',
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


  /// =========================================================
  /// TEMPLATE T002
  /// =========================================================

  static Widget templateT002(dynamic job) {
    return Container(
      decoration: BoxDecoration(

        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffD46ACB),
            Color(0xffB94EB2),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ClipRRect(

        child: Stack(
          fit: StackFit.expand,
          children: [

            /// TEXTURE
            Opacity(
              opacity: .10,
              child: Image.asset(
                "assets/images/img.png",
                fit: BoxFit.cover,
              ),
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 16,
              ),

              child: Column(
                children: [

                  /// TOP TITLE
                  const Text(
                    "JOB\nOPENING",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      height: .84,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// COMPANY
                  Text(
                    job['business_name'] ??
                        '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff5A0068),
                      fontWeight:
                      FontWeight.w700,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ROLE
                  Text(
                    (job['job_role'] ?? '')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      height: .95,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.w900,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// JOB TYPE
                  Text(
                    (job['job_type'] ??
                        'FULL-TIME')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff5A0068),
                      fontWeight:
                      FontWeight.w900,
                      fontFamily: 'serif',
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// SALARY
                  Text(
                    "₹${job['salary'] ?? '12,000'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Color(0xff5A0068),
                      fontWeight:
                      FontWeight.w900,
                      fontFamily: 'serif',
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



  /// =========================================================
  /// TEMPLATE T003
  /// =========================================================

  static Widget templateT003(dynamic job) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffE5DB2F),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ClipRRect(

        child: Stack(
          fit: StackFit.expand,
          children: [

            /// PAPER TEXTURE
            Opacity(
              opacity: .10,
              child: Image.asset(
                "assets/images/paper_bg.png",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),

              child: Column(
                children: [

                  /// HIRING BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xff5F0B75),
                    ),

                    child: const Text(
                      "Urgently\nHiring",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        height: .92,
                        color: Color(0xffFFF45A),
                        fontWeight:
                        FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// COMPANY
                  Text(
                    (job['business_name'] ??
                        '')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff5F0B75),
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  const Spacer(),

                  /// ROLE
                  Text(
                    (job['job_role'] ?? '')
                        .replaceAll(
                      ' ',
                      '\n',
                    )
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      height: .92,
                      color: Color(0xff5F0B75),
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TYPE + SALARY
                  Text(
                    "${(job['job_type'] ?? 'PART-TIME').toUpperCase()} | ₹${job['salary'] ?? '25,000'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff5F0B75),
                      fontWeight:
                      FontWeight.w800,
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


  /// =========================================================
  /// TEMPLATE T004
  /// =========================================================

  static Widget templateT004(dynamic job) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: ClipRRect(

        child: Stack(
          fit: StackFit.expand,
          children: [

            /// TEXTURE
            Opacity(
              opacity: .08,
              child: Image.asset(
                "assets/images/img.png",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),

              child: Column(
                children: [

                  /// WE'RE
                  const Text(
                    "WE’RE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      height: .9,
                      color: Colors.black,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// HIRING STRIP
                  Transform.rotate(
                    angle: -.03,
                    child: Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.symmetric(
                        vertical: 10,
                      ),

                      color: const Color(
                        0xffFFE600,
                      ),

                      child: const Text(
                        "HIRING",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          height: .9,
                          color: Colors.black,
                          fontWeight:
                          FontWeight.w900,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// COMPANY
                  Text(
                    (job['business_name'] ??
                        '')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xffE0B800),
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  const Spacer(),

                  /// ROLE
                  Text(
                    (job['job_role'] ?? '')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      height: .95,
                      color: Colors.black87,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// JOB TYPE
                  Text(
                    (job['job_type'] ??
                        'FULL-TIME')
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight:
                      FontWeight.w900,
                    ),
                  ),

                  /// SALARY
                  Text(
                    "₹${job['salary'] ?? '12,000'}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight:
                      FontWeight.w900,
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
  /// =========================================================
  /// DEFAULT TEMPLATE
  /// =========================================================

  static Widget defaultTemplate(
      dynamic job) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xffFFFFFF),
            Color(0xffF4F1FF),
          ],
        ),


        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          /// VIEWS
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),

              decoration: BoxDecoration(
                color:
                const Color(0xffECE9FF),
              ),

              child: Row(
                mainAxisSize:
                MainAxisSize.min,

                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    size: 16,
                    color:
                    Color(0xff5B5FFF),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    "${job['view_count']}",
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          Text(
            job['business_name'] ?? '',
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.w800,
              color: Color(0xff111827),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            job['job_role'] ?? '',
            maxLines: 2,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight:
              FontWeight.w600,
              color: Color(0xff6B7280),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: Colors.red,
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  job['city'] ?? '',
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}