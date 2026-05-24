import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xffE5E5E5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 30),
                      bottomRight: Radius.elliptical(200, 30),
                    ),
                  ),
                ),
                Positioned(
                  top: 56,
                  left: 30,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(CupertinoIcons.back, size: 30),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200, left: 70, right: 55),
                  child: Transform.rotate(
                    angle: -0.07,
                    child: ClipPath(
                      clipper: TicketClipper(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 33, horizontal: 25),
                        decoration: BoxDecoration(
                          color: const Color(0xffB4B4B4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "Refer Friends & Earn\nPoster Credits",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'ClashDisplay',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Help other businesses promote smarter\nwith PosterGali and earn rewards when\nthey create their first poster",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "For Your Friend",
                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: const Color(0xffD9D9D9),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹1000 Poster Credits",
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "To create and promote their first posters.",
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "For You",
                    style: TextStyle(
                      fontFamily: 'ClashDisplay',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        color: const Color(0xffD9D9D9),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹100 Poster Credits",
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Added to your wallet after their first successful poster.",
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Center(
                    child: Text(
                      "How it works?",
                      style: TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildStep(
                    "Invite Friends",
                    "Share your referral through WhatsApp or SMS.",
                    isLast: false,
                  ),
                  _buildStep(
                    "They create poster",
                    "Your friend joins and publishes their first poster.",
                    isLast: false,
                  ),
                  _buildStep(
                    "Earn Rewards",
                    "Credits are added automatically to both accounts.",
                    isLast: true,
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 62,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffA6A6A6),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          "Refer now",
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String subtitle, {required bool isLast}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 16,
                width: 16,
                color: const Color(0xffD9D9D9),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xffD9D9D9),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'ClashDisplay',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'HelveticaNeue',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height / 2 - 12);
    path.arcToPoint(Offset(0, size.height / 2 + 12), radius: const Radius.circular(12), clockwise: true);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 2 + 12);
    path.arcToPoint(Offset(size.width, size.height / 2 - 12), radius: const Radius.circular(12), clockwise: true);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
