import 'package:flutter/material.dart';

class SubmissionProcessingScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onComplete;

  const SubmissionProcessingScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onComplete,
  });

  @override
  State<SubmissionProcessingScreen> createState() => _SubmissionProcessingScreenState();
}

class _SubmissionProcessingScreenState extends State<SubmissionProcessingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _characterTranslate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _characterTranslate = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Simulate process completion
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F1E7),
      body: Stack(
        children: [
          // Background Texture
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/img.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // Character Illustration
                AnimatedBuilder(
                  animation: _characterTranslate,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _characterTranslate.value),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFFE600).withOpacity(0.3),
                            ),
                          ),
                          Image.asset(
                            'assets/images/img_14.png', // Assuming img_14 is the running character
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.directions_run,
                              size: 150,
                              color: Color(0xffB33B2E),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff333333),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  widget.subtitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                
                const Spacer(flex: 3),
                
                // Warning Box
                Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFF3E0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xffFFE0B2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Please do not close the app or press the back button till the transaction is complete.",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff8D6E63),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}