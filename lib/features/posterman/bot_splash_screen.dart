import 'dart:async';
import 'package:flutter/material.dart';
import 'package:postergali/features/posterman/poster_man_chat_screen.dart';

class BotSplashScreen extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;

  const BotSplashScreen({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
  });


  @override
  State<BotSplashScreen> createState() => _BotSplashScreenState();
}

class _BotSplashScreenState extends State<BotSplashScreen> {

  @override
  void initState() {
    super.initState();

    /// simulate loading / API init / animation delay
    Timer(const Duration(milliseconds: 1200), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PosterManChatScreen(
            location: widget.location,
            latitude: widget.latitude,
            longitude: widget.longitude,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffA53A2E),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

            Icon(
              Icons.auto_awesome,
              size: 60,
              color: Color(0xffF3C35D),
            ),

            SizedBox(height: 15),

            Text(
              "Preparing Chatbot...",
              style: TextStyle(
                color: Color(0xffF3C35D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 20),

            CircularProgressIndicator(
              color: Color(0xffF3C35D),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}