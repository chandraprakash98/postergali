import 'package:flutter/material.dart';
import 'package:postergali/features/posterman/plan.dart';

import '../posterman/plan_selection.dart';

class CheckoutScreen extends StatefulWidget {
  final PlanModel plan;
  const CheckoutScreen({
    super.key,
    required this.plan,
  });


  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool applyCredits = true;
  bool gstInvoice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6d189),

      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Text(
                        "PAYING VIA",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 90,
                    child: Divider(
                      thickness: 8,
                      color: Color(0xffD9D9D9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 240,
              height: 65,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffBDBDBD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Pay Now",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 18),

            // ORDER SUMMARY
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [

                  const Padding(
                    padding: EdgeInsets.all(22),
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 30),
                        SizedBox(width: 12),
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.black26),

                  _row("Poster Plan", widget.plan.duration),
                  _row("Amount", "₹${amount.toStringAsFixed(2)}"),
                  _row("Estimated Tax", "₹${getGstAmount().toStringAsFixed(2)}"),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Grand Total",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          "₹${getGrandTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final PlanModel? plan = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PlanSelectionScreen(),
                      ),
                    );

                    if (plan != null) {
                      setState(() {
                        var selectedPlan = plan;
                      });
                    }
                  },
                  child: const Text(
                    "Change Plan",
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),

            // CREDITS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [

                  ListTile(
                    leading: const Icon(Icons.discount_outlined),
                    title: const Text(
                      "Use Poster Credits",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: const Text("₹120 credits available"),
                    trailing: const Icon(Icons.keyboard_arrow_down),
                  ),

                  Container(
                    color: Colors.white.withOpacity(.3),
                    child: CheckboxListTile(
                      value: applyCredits,
                      activeColor: Colors.black,
                      title: const Text(
                        "Apply poster credits",
                        style: TextStyle(fontSize: 18),
                      ),
                      onChanged: (v) {
                        setState(() {
                          applyCredits = v!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(
                left: 32,
                top: 10,
                right: 32,
              ),
              child: Text(
                "Remaining amount will be charged online after credits are used",
              ),
            ),

            const SizedBox(height: 30),

            // CHECKOUT BOX
            Container(
              width: double.infinity,
              color: const Color(0xffD9D9D9),
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  _row("Poster Plan", "3 Days"),
                  _row("Amount", "₹49.99"),
                  _rowBold("Credits Applied", "₹49.99"),
                  _row("Estimated Tax", "₹9"),

                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xffBDBDBD),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          "₹9",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xffBDBDBD),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You've saved ₹49.99",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Total credits left ₹950.01",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius:
                            BorderRadius.circular(24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // GST
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffD9D9D9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.receipt),
                title: const Text(
                  "Get GST Invoice",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "Claim up to 18% with the GST Invoice",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  static Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  static Widget _rowBold(String title, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  double get amount {
    return double.tryParse(widget.plan.price.toString()) ?? 0;
  }

  double getGstPercent(int planId) {
    // Static values for now
    switch (planId) {
      case 1:
        return 10; // 10%
      case 2:
        return 9; // 9%
      case 3:
        return 12; // 12%
      default:
        return 18; // default GST
    }
  }

  double getGstAmount() {
    return amount * (getGstPercent(widget.plan.id) / 100);
  }

  double getGrandTotal() {
    return amount + getGstAmount();
  }



}