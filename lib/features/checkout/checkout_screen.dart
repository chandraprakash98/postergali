import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postergali/core/localization/localization_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:postergali/features/posterman/plan.dart';
import 'package:postergali/features/posterman/api_service.dart';
import 'package:postergali/features/posterman/offer/offer_request.dart';
import 'package:postergali/core/job_request.dart';

enum CheckoutFlowType { job, offer }

class CheckoutScreen extends StatefulWidget {
  final PlanModel plan;
  final CheckoutFlowType flowType;
  final dynamic request; // JobRequest or OfferRequest
  final List<File>? images; // For Offer flow
  final File? video; // For Offer flow

  const CheckoutScreen({
    super.key,
    required this.plan,
    required this.flowType,
    required this.request,
    this.images,
    this.video,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Razorpay _razorpay;
  bool applyCredits = true;
  bool gstInvoice = false;
  
  double userCredits = 120.0; // Mock credits
  late double planAmount;
  late double creditsApplied;
  late double grandTotal;

  @override
  void initState() {
    super.initState();
    planAmount = double.tryParse(widget.plan.price) ?? 0.0;
    _calculateTotals();
    
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _calculateTotals() {
    creditsApplied = applyCredits ? (userCredits > planAmount ? planAmount : userCredits) : 0.0;
    grandTotal = planAmount - creditsApplied;
    if (grandTotal < 0) grandTotal = 0;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _submitData();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
  }

  void _openRazorpay() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Initializing payment..."), duration: Duration(seconds: 1)),
    );

    if (grandTotal <= 0) {
      _submitData();
      return;
    }

    var options = {
      'key': 'rzp_test_ShzedmMOKHIUDt', 
      'amount': (grandTotal * 100).toInt(),
      'name': 'PosterGali',
      'description': 'Payment for ${widget.plan.title} Plan',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': widget.flowType == CheckoutFlowType.job 
            ? (widget.request as JobRequest).phoneNumber 
            : (widget.request as OfferRequest).mobileNumber,
        'email': 'user@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      print("Calling _razorpay.open with options: $options");
      _razorpay.open(options);
    } catch (e) {
      print("Razorpay Exception: $e");
      debugPrint('Error: $e');
    }
  }

  Future<void> _submitData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    final apiService = ApiService();

    if (widget.flowType == CheckoutFlowType.job) {
      success = await apiService.submitJob(widget.request as JobRequest);
    } else {
      success = await apiService.submitOffer(
        request: widget.request as OfferRequest,
        images: widget.images ?? [],
        video: widget.video,
      );
    }

    if (!mounted) return;
    Navigator.pop(context); // Close loading dialog

    if (success) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit. Please try again.")),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Icon(Icons.check_circle, color: Colors.green, size: 60),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Payment Successful!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              "Your ${widget.flowType == CheckoutFlowType.job ? 'job' : 'offer'} poster has been submitted successfully.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Go to Home", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7EF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8B4513)),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Color(0xFF8B4513), size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('checkout'),
          style: const TextStyle(
            color: Color(0xFF4A2511),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Order Summary Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5B342),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long, color: Color(0xFF4A2511)),
                        const SizedBox(width: 10),
                        Text(
                          context.tr('order_summary'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2511),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.5),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _summaryRow(context.tr('poster_plan'), widget.plan.duration),
                        const SizedBox(height: 12),
                        _summaryRow(context.tr('amount'), "₹${planAmount.toStringAsFixed(2)}"),
                        const SizedBox(height: 12),
                        _summaryRow(context.tr('apply_credits'), "₹${creditsApplied.toStringAsFixed(2)}", isBold: true),
                        const SizedBox(height: 12),
                        _summaryRow(context.tr('total'), "₹${(planAmount - creditsApplied).toStringAsFixed(2)}"),
                        const SizedBox(height: 12),
                        _summaryRow(context.tr('tax'), "₹0"),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('grand_total'),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "₹${grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  context.tr('change_plan'),
                  style: const TextStyle(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),

            // Use Poster Credits Section
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF438F5B), Color(0xFF5DBE7E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.percent, color: Colors.red, size: 18),
                    ),
                    title: Text(
                      context.tr('use_credits'),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "₹${userCredits.toStringAsFixed(0)} ${context.tr('credits_available')}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: CheckboxListTile(
                      value: applyCredits,
                      onChanged: (val) {
                        setState(() {
                          applyCredits = val!;
                          _calculateTotals();
                        });
                      },
                      title: Text(context.tr('apply_credits')),
                      activeColor: const Color(0xFFB34233),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Savings Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5B342), Color(0xFFF9D18A)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "You've saved ₹${creditsApplied.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Total credits left ₹${(userCredits - creditsApplied).toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.savings, color: Colors.orange, size: 40),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // GST Invoice Section
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFFFF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB8E6CC)),
              ),
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Color(0xFFB34233)),
                title: Text(
                  context.tr('gst_invoice'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(context.tr('gst_desc')),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),

            const SizedBox(height: 40),

            // Pay Now Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _openRazorpay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00C853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  context.tr('pay_now'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
