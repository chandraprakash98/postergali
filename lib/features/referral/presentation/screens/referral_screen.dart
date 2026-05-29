import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postergali/features/referral/presentation/screens/refer_friend_form_screen.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7E7B4), // Golden background
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 390,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 30),
                      bottomRight: Radius.elliptical(200, 30),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/img_8.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Dark overlay
                Container(
                  height: 390,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: const BorderRadius.only(
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
                    child: const Icon(
                      CupertinoIcons.back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.only(top: 298, left: 22, right: 22),
                  child: Transform.rotate(
                    angle: -0.05,
                    child: ClipPath(
                      clipper: TicketClipper(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 28,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffb33d22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
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
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              "Help other businesses promote smarter\nwith PosterGali and earn rewards when\nthey create their first poster",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                height: 1.4,
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
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  // =======================
                  // FRIEND + YOU SINGLE CARD
                  // =======================
                  // ======================
// FOR YOU + FRIEND CARD
// ======================

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEFE4D2),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xffE3A93B),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ================= FOR YOU =================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xff1B5E20),
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/img_9.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "For You",
                                    style: TextStyle(
                                      fontFamily: 'ClashDisplay',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff4A1F14),
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    "₹100 Poster Credits",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "Added to your wallet after their first successful poster.",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Divider(
                          color: Colors.black.withOpacity(0.12),
                          thickness: 1,
                        ),

                        const SizedBox(height: 10),

                        // ================= FOR FRIEND =================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xff1B5E20),
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/img_9.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "For Your Friend",
                                    style: TextStyle(
                                      fontFamily: 'ClashDisplay',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff4A1F14),
                                    ),
                                  ),

                                  SizedBox(height: 8),

                                  Text(
                                    "₹1000 Poster Credits",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "To create and promote their first posters.",
                                    style: TextStyle(
                                      fontFamily: 'HelveticaNeue',
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // =======================
                  // HOW IT WORKS CARD
                  // =======================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "How it Works?",
                          style: TextStyle(
                            fontFamily: 'ClashDisplay',
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 30),

                        _buildStep(
                          "Invite Friends",
                          "Share your referral through WhatsApp or SMS.",
                          icon: CupertinoIcons.paperplane_fill,
                          isLast: false,
                        ),

                        _buildStep(
                          "They Create Poster",
                          "Your friend joins and publishes their first poster.",
                          icon: CupertinoIcons.photo_fill_on_rectangle_fill,
                          isLast: false,
                        ),

                        _buildStep(
                          "Earn Rewards",
                          "Credits are added automatically to both accounts.",
                          icon: CupertinoIcons.star_fill,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 34),

                  // REFER BUTTON
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReferFriendFormScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 64,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffD4A017),
                            Color(0xffB8860B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Refer Now",
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

  static Widget _rewardCard({
    required String title,
    required String reward,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: const Color(0xffB8860B),
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            reward,
            style: const TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xffB8860B),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStep(
      String title,
      String subtitle, {
        required IconData icon,
        required bool isLast,
      }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xffF4E3B2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xffB8860B),
                  size: 22,
                ),
              ),

              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xffE0D2A2),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
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
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 26),
                ],
              ),
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

    path.arcToPoint(
      Offset(0, size.height / 2 + 12),
      radius: const Radius.circular(12),
      clockwise: true,
    );

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    path.lineTo(size.width, size.height / 2 + 12);

    path.arcToPoint(
      Offset(size.width, size.height / 2 - 12),
      radius: const Radius.circular(12),
      clockwise: true,
    );

    path.lineTo(size.width, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}