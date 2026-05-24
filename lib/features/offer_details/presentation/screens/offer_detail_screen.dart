import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfferDetailScreen extends StatefulWidget {
  final int offerId;

  const OfferDetailScreen({
    super.key,
    required this.offerId,
  });

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen> {
  bool isLoading = true;
  dynamic offer;

  @override
  void initState() {
    super.initState();
    fetchOffer();
  }

  Future<void> fetchOffer() async {
    try {
      final response = await http.get(
        Uri.parse('https://postergali.com/api/v1/offers/${widget.offerId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          offer = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer['business_name'] ?? '',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    _item("Offer", offer['offer_details']),
                    _item("Phone", offer['mobile_number']),
                    _item("City", offer['city']),
                    _item("Views", "${offer['view_count']}"),
                    _item("Plan", offer['plan_id']),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _item(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value ?? '',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
