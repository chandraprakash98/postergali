import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPosterScreen extends StatefulWidget {
  final String shopName;
  final String? jobRole;
  final String? jobType;
  final String? salary;
  final String phone;
  final String? offerDetails;
  final List<File>? images;
  final File? video;
  final bool isOffer;

  const EditPosterScreen({
    super.key,
    required this.shopName,
    this.jobRole,
    this.jobType,
    this.salary,
    required this.phone,
    this.offerDetails,
    this.images,
    this.video,
    this.isOffer = false,
  });

  @override
  State<EditPosterScreen> createState() => _EditPosterScreenState();
}

class _EditPosterScreenState extends State<EditPosterScreen> {
  late TextEditingController shopController;
  late TextEditingController phoneController;
  late TextEditingController detailController;
  
  List<File> images = [];
  File? video;
  String selectedOfferType = "Special Offer";

  final List<String> offerTypes = [
    "Grand Opening Offer",
    "Announcement",
    "New Arrivals",
    "Special Offer",
    "Sale Sale Sale"
  ];

  @override
  void initState() {
    super.initState();
    shopController = TextEditingController(text: widget.shopName);
    phoneController = TextEditingController(text: widget.phone);
    detailController = TextEditingController(text: widget.isOffer ? widget.offerDetails : widget.jobRole);
    
    if (widget.images != null) {
      images = List.from(widget.images!);
    }
    video = widget.video;
    
    if (widget.isOffer && widget.offerDetails != null) {
      if (offerTypes.contains(widget.offerDetails)) {
        selectedOfferType = widget.offerDetails!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF8F0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.only(top: 40, left: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff8D3B2D), width: 1),
                  ),
                  child: const Icon(Icons.arrow_back, color: Color(0xff8D3B2D), size: 24),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                "Edit poster",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff4A1F14),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Business Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff333333))),
            const SizedBox(height: 10),
            TextField(
              controller: shopController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xff8D3B2D)),
                  onPressed: () => shopController.clear(),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xff8D3B2D))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xff8D3B2D))),
              ),
            ),
            
            const SizedBox(height: 25),
            
            const Text("Edit Phone Number", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff333333))),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff8D3B2D)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Image.asset('assets/images/img_12.png', width: 24, height: 16), // Use a flag icon if available
                        const SizedBox(width: 8),
                        const Text("+91", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Color(0xff8D3B2D)),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 25),
            
            Text(widget.isOffer ? "Offer" : "Job Role", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff333333))),
            const SizedBox(height: 10),
            if (widget.isOffer)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff8D3B2D)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(selectedOfferType, style: const TextStyle(color: Colors.grey)),
                        trailing: const Icon(Icons.keyboard_arrow_down, color: Color(0xff8D3B2D)),
                        children: offerTypes.map((type) => ListTile(
                          title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff8D3B2D))),
                          onTap: () {
                            setState(() => selectedOfferType = type);
                          },
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              )
            else
              TextField(
                controller: detailController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xff8D3B2D))),
                ),
              ),

            const SizedBox(height: 25),
            
            const Text("Add photos & videos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xff333333))),
            const SizedBox(height: 12),
            Container(
              height: 160,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffFFF7E6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffFDE6A6)),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...images.map((f) => Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(image: FileImage(f), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 5,
                        child: GestureDetector(
                          onTap: () => setState(() => images.remove(f)),
                          child: const Icon(Icons.more_horiz, color: Colors.white),
                        ),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: _pickVideo,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xff8D3B2D), style: BorderStyle.solid), // Should be dashed
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.videocam_outlined, color: Color(0xff8D3B2D), size: 40),
                          const SizedBox(height: 8),
                          const Text("Add a video", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("[1 min | 200 mb]", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "shopName": shopController.text,
                    "phone": phoneController.text,
                    if (widget.isOffer) "offerDetails": selectedOfferType else "jobRole": detailController.text,
                    "images": images,
                    "video": video,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffB33B2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                ),
                child: const Text("Confirm", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        video = File(pickedFile.path);
      });
    }
  }
}