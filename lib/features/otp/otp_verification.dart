import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import '../posterman/plan.dart';
import '../checkout/checkout_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;
  final PlanModel plan;
  final CheckoutFlowType flowType;
  final dynamic request;
  final List<File>? images;
  final File? video;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
    required this.plan,
    required this.flowType,
    required this.request,
    this.images,
    this.video,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  int seconds = 12;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      seconds = 12;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (seconds == 0) {
          timer.cancel();
        } else {
          setState(() {
            seconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();

    for (var c in controllers) {
      c.dispose();
    }

    super.dispose();
  }

  String get timerText {
    return "00:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F1E7),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(95),
        child: Container(
          padding: const EdgeInsets.only(
            top: 45,
            left: 20,
            right: 20,
          ),
          decoration: const BoxDecoration(
            color: Color(0xffF5F1E7),
            border: Border(
              bottom: BorderSide(
                color: Color(0xffB33B2E),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffB33B2E),
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xffB33B2E),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                context.tr('otp_verification'),
                style: const TextStyle(
                  color: Color(0xff4A1711),
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/otp_bg.png",
            ),
            fit: BoxFit.cover,
            opacity: 0.08,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 70),

                Text(
                  "${context.tr('otp_sent')}\n${widget.mobileNumber}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff333333),
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 70),

                Text(
                  context.tr('enter_otp'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff333333),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                        (index) => Container(
                      width: 72,
                      height: 72,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: controllers[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: const Color(0xffE7DDC8),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xffF0A319),
                              width: 1.8,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xffF0A319),
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }

                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 55),

                Text(
                  "${context.tr('otp_expires')} $timerText",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff2F6D4D),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  context.tr('didnt_get_otp'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff2F6D4D),
                  ),
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: startTimer,
                  child: Text(
                    context.tr('resend_otp'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff2F6D4D),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 78,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            plan: widget.plan,
                            flowType: widget.flowType,
                            request: widget.request,
                            images: widget.images,
                            video: widget.video,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffB33B2E),
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      context.tr('confirm'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
