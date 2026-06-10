import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:postergali/core/job_request.dart';
import 'package:postergali/core/widgets/job_templates_small.dart';
import 'package:postergali/core/widgets/offer_templates.dart';
import 'package:postergali/features/posterman/offer/offer_controller.dart';
import 'package:postergali/features/posterman/posterman_controller.dart';
import '../otp/otp_verification.dart';
import 'api_service.dart';
import 'edit_poster.dart';
import 'edit_offer_poster.dart';
import 'location_service.dart';
import 'plan.dart';

class PosterManChatScreen extends StatefulWidget {
  final String location;
  final double latitude;
  final double longitude;

  const PosterManChatScreen({
    super.key,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<PosterManChatScreen> createState() => _PosterManChatScreenState();
}

enum ChatStep {
  welcome,
  chooseType,
  businessName,
  locationConfirm,
  // Job specific
  jobRole,
  jobTypeSelect,
  salary,
  // Offer specific
  offerSubCategory,
  offerDetails,
  offerMedia,
  // Common
  phone,
  planSelect,
  layoutSelect,
  done
}

enum FlowType { job, offer }

class _PosterManChatScreenState extends State<PosterManChatScreen> {
  late PosterManController controller;
  late OfferController offerController;

  final TextEditingController input = TextEditingController();
  final ScrollController scroll = ScrollController();

  ChatStep step = ChatStep.welcome;
  FlowType flowType = FlowType.job;

  List<Map<String, dynamic>> messages = [];
  bool isBotTyping = false;

  LatLng? selectedLatLng;
  PlanModel? selectedPlan;

  // Warmer theme color
  final Color primaryColor = const Color(0xFFE67E22);

  @override
  void initState() {
    super.initState();

    controller = PosterManController(
      locationService: LocationService(),
      apiService: ApiService(),
    );

    offerController = OfferController(
      locationService: LocationService(),
      apiService: ApiService(),
    );

    selectedLatLng = LatLng(widget.latitude, widget.longitude);
    controller.lat = widget.latitude;
    controller.lng = widget.longitude;
    controller.city = widget.location;

    offerController.lat = widget.latitude;
    offerController.lng = widget.longitude;
    offerController.city = widget.location;

    _startFlow();
  }

  Future<void> bot(String text) async {
    setState(() => isBotTyping = true);
    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      isBotTyping = false;
      messages.add({"bot": true, "type": "text", "text": text});
    });

    scrollToBottom();
  }

  void user(String text) {
    setState(() {
      messages.add({"bot": false, "type": "text", "text": text});
    });
    scrollToBottom();
  }

  Future<void> _startFlow() async {
    await bot("Welcome to PosterGali!\nCreate and publish posters easily 🚀\nIn this chat, I'll ask some question for which you need to answer correctly.\n\nLet's get started 😊");
    setState(() => step = ChatStep.chooseType);
    await bot("Please choose what type of service you want to use:");
    addTypeChips();
  }

  void addTypeChips() {
    messages.add({"bot": true, "type": "type_chips"});
    setState(() {});
    scrollToBottom();
  }

  void addOfferSubCategoryChips() {
    messages.add({"bot": true, "type": "offer_subcategory_chips"});
    setState(() {});
    scrollToBottom();
  }

  void addOfferMediaCard() {
    messages.add({"bot": true, "type": "offer_media"});
    setState(() {});
    scrollToBottom();
  }

  void addJobTypeChips() {
    messages.add({"bot": true, "type": "job_type_chips"});
    setState(() {});
    scrollToBottom();
  }

  void addLocationMap() {
    messages.add({"bot": true, "type": "location_map"});
    setState(() {});
    scrollToBottom();
  }

  void addPlanSelection() {
    messages.add({"bot": true, "type": "plan_selection"});
    setState(() {});
    scrollToBottom();
  }

  void addLayoutSelection() {
    messages.add({"bot": true, "type": "layout_selection"});
    setState(() {});
    scrollToBottom();
  }

  void addFinalConfirmation() {
    messages.add({"bot": true, "type": "final_confirmation"});
    setState(() {});
    scrollToBottom();
  }

  void next(String text) async {
    if (text.isEmpty) return;

    user(text);

    if (flowType == FlowType.job) {
      await _handleJobFlow(text);
    } else {
      await _handleOfferFlow(text);
    }

    input.clear();
    scrollToBottom();
  }

  Future<void> _handleJobFlow(String text) async {
    switch (step) {
      case ChatStep.chooseType:
        if (text.toLowerCase().contains("hiring")) {
          flowType = FlowType.job;
          step = ChatStep.businessName;
          await bot("What is your business name &\naddress where you want job?");
        } else {
          flowType = FlowType.offer;
          step = ChatStep.businessName;
          await bot("Let’s start with your business name 🏪\n"
              "What is the name of your business?");
        }
        break;

      case ChatStep.businessName:
        controller.businessName = text;
        await bot("📍 Your business location");
        addLocationMap();
        setState(() => step = ChatStep.locationConfirm);
        break;

      case ChatStep.locationConfirm:
        await bot("Great! 👍 Now tell us job role");
        await bot("Examples: Helper, Cook, Delivery Boy, Painter, Security Guard");
        setState(() => step = ChatStep.jobRole);
        break;

      case ChatStep.jobRole:
        controller.jobRole = text;
        await bot("What type of job is it?");
        addJobTypeChips();
        setState(() => step = ChatStep.jobTypeSelect);
        break;

      case ChatStep.jobTypeSelect:
        controller.jobType = text;
        await bot("What is the salary in Rupees? 💰");
        await bot("Example salary: ₹15,000 - ₹18,000");
        setState(() => step = ChatStep.salary);
        break;

      case ChatStep.salary:
        controller.salary = int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 15000;
        await bot("Please enter mobile number on which job seekers can call you 📞");
        setState(() => step = ChatStep.phone);
        break;

      case ChatStep.phone:
        controller.phone = text;
        await bot("Please select your plan below 👇");
        await bot("Select how long you want to display your post.");
        setState(() => isBotTyping = true);
        await controller.loadPlans();
        setState(() => isBotTyping = false);
        addPlanSelection();
        setState(() => step = ChatStep.planSelect);
        break;

      case ChatStep.planSelect:
        await bot("📍 Your poster layouts!");
        await bot("All you have to do is select any one layout below and we'll create a poster for you style ✨");
        addLayoutSelection();
        setState(() => step = ChatStep.layoutSelect);
        break;

      case ChatStep.layoutSelect:
        await bot("Ready to display the poster?");
        await bot("👉 Tap the button below to post");
        addFinalConfirmation();
        setState(() => step = ChatStep.done);
        break;

      default:
        break;
    }
  }

  Future<void> _handleOfferFlow(String text) async {
    switch (step) {
      case ChatStep.chooseType:
        if (text.toLowerCase().contains("hiring")) {
          flowType = FlowType.job;
          step = ChatStep.businessName;
          await bot("What is your business name &\naddress where you want job?");
        } else {
          flowType = FlowType.offer;
          step = ChatStep.businessName;
          await bot("Great! Please tell us about your business");
        }
        break;

      case ChatStep.businessName:
        offerController.businessName = text;
        await bot("📍 Your business location");
        addLocationMap();
        setState(() => step = ChatStep.locationConfirm);
        break;

      case ChatStep.locationConfirm:
        await bot("🎯 What type of offer would you like to create? \n"
            "Choose one that matches your business 👇");
        addOfferSubCategoryChips();
        setState(() => step = ChatStep.offerSubCategory);
        break;

      case ChatStep.offerSubCategory:
        offerController.subCategory = text;
        offerController.offerType = text;
        await bot("Great! 👍\n"
        "What would you like to showcase in your offer? \n"

    "Examples:\n"
    "• 50% off on all items \n"
    "• Fresh homemade tiffin available\n"
    "• Opening offer for the new salon");
        setState(() => step = ChatStep.offerDetails);
        break;

      case ChatStep.offerDetails:
        offerController.offerDetails = text;
        await bot("Upload some images or videos of your offer... \nSelect photos of products or shop");
        addOfferMediaCard();
        setState(() => step = ChatStep.offerMedia);
        break;

      case ChatStep.offerMedia:
        await bot("Please enter mobile number on which seekers can call you 📞");
        setState(() => step = ChatStep.phone);
        break;

      case ChatStep.phone:
        offerController.mobile = text;
        await bot("Please select your plan below 👇");
        await bot("Select how long you want to display your post.");
        setState(() => isBotTyping = true);
        await offerController.loadPlans();
        setState(() => isBotTyping = false);
        addPlanSelection();
        setState(() => step = ChatStep.planSelect);
        break;

      case ChatStep.planSelect:
        await bot("📍 Your poster layouts!");
        await bot("All you have to do is select any one layout below and we'll create a poster for you style ✨");
        addLayoutSelection();
        setState(() => step = ChatStep.layoutSelect);
        break;

      case ChatStep.layoutSelect:
        await bot("Ready to display the poster?");
        await bot("👉 Tap the button below to post");
        addFinalConfirmation();
        setState(() => step = ChatStep.done);
        break;

      default:
        break;
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 10),
            const Text(
              "Poster Man",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scroll,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length + (isBotTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (isBotTyping && i == messages.length) {
                  return _typingIndicator();
                }

                final m = messages[i];

                switch (m["type"]) {
                  case "type_chips":
                    return _typeChips();
                  case "offer_subcategory_chips":
                    return _offerSubCategoryChips();
                  case "offer_media":
                    return _offerMediaCard();
                  case "job_type_chips":
                    return _jobTypeChips();
                  case "location_map":
                    return _locationMapCard();
                  case "plan_selection":
                    return _planSelection();
                  case "layout_selection":
                    return _layoutSelection();
                  case "final_confirmation":
                    return _finalConfirmation();
                  default:
                    return _bubble(m);
                }
              },
            ),
          ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _typingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text("Typing...", style: TextStyle(color: Colors.grey, fontSize: 14)),
      ),
    );
  }

  Widget _bubble(Map m) {
    bool isBot = m["bot"];
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isBot
              ? const Color(0xFF2F590F) // Bot green
              : const Color(0xFFCC501C), // Terracotta 700
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isBot ? 4 : 16),
            bottomRight: Radius.circular(isBot ? 16 : 4),
          ),
          boxShadow: [
            if (isBot)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Text(
          m["text"] ?? "",
          style: TextStyle(
            color: isBot ? Colors.white : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _typeChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 10,
        children: [
          _chip("Job Hiring", () => next("Job Hiring")),
          _chip("Offer Others", () => next("Offer Others")),
        ],
      ),
    );
  }

  Widget _offerSubCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        children: [
          _chip("Sale Sale Sale", () => next("Sale Sale Sale")),
          _chip("Special Offer", () => next("Special Offer")),
          _chip("Grand Opening Offer", () => next("Grand Opening Offer")),
          _chip("Inauguration Sale", () => next("Inauguration Sale")),
          _chip("New Arrivals", () => next("New Arrivals")),
        ],
      ),
    );
  }

  Widget _offerMediaCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📸 Upload Media",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Select images or video for your offer poster",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (offerController.images.isNotEmpty || offerController.video != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...offerController.images.map((f) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(f, width: 70, height: 70, fit: BoxFit.cover),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => setState(() => offerController.images.remove(f)),
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      )),
                  if (offerController.video != null)
                    Stack(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.videocam, color: Colors.white),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => offerController.video = null),
                            child: Container(
                              color: Colors.black54,
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final List<XFile> pickedFiles = await picker.pickMultiImage();
                    if (pickedFiles.isNotEmpty) {
                      setState(() {
                        offerController.images.addAll(pickedFiles.map((x) => File(x.path)));
                      });
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("Images"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        offerController.video = File(pickedFile.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.videocam),
                  label: const Text("Video"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => next("Media uploaded ✅"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _jobTypeChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _chip("Full Time", () => next("Full Time")),
          _chip("Part Time", () => next("Part Time")),
          _chip("Temporary", () => next("Temporary")),
        ],
      ),
    );
  }

  Widget _chip(String label, VoidCallback onPressed) {
    return ActionChip(
      backgroundColor: const Color(0xFFBED6A5),
      label: Text(label, style: const TextStyle(color: Colors.black)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: Colors.grey, width: 0.5),
      onPressed: onPressed,
    );
  }

  Widget _locationMapCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF32600D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📍 Your business location",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            widget.location,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLatLng ?? const LatLng(28, 77),
                zoom: 14,
              ),
              markers: {
                if (selectedLatLng != null)
                  Marker(
                    markerId: const MarkerId("current"),
                    position: selectedLatLng!,
                  )
              },
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: false,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.my_location, size: 18),
              label: const Text("Use current location"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              onPressed: () => next("Location selected 👍"),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Enter New Address"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _planSelection() {
    final plans = flowType == FlowType.job ? controller.plans : offerController.plans;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: plans.map((p) => _planCard(p)).toList(),
      ),
    );
  }

  Widget _planCard(PlanModel p) {
    String planName = p.title.toLowerCase();

    Color bgColor;
    Color borderColor;
    Color textColor;
    Color chipColor;
    String bgImage;

    switch (planName) {
      case "standerd":
        bgColor = const Color(0xFFFFEBEE); // Light Red
        borderColor = const Color(0xFFD32F2F);
        textColor = const Color(0xFFB71C1C);
        chipColor = const Color(0xFFFFCDD2);
        break;

      case "starter":
        bgColor = const Color(0xFFFFF8E1); // Light Amber
        borderColor = const Color(0xFFF19A05);
        textColor = const Color(0xFFEF6C00);
        chipColor = const Color(0xFFFFE082);
        break;

      case "basic":
        bgColor = const Color(0xFFE8F5E9); // Light Green
        borderColor = const Color(0xFF2E7D32);
        textColor = const Color(0xFF1B5E20);
        chipColor = const Color(0xFFA5D6A7);
        break;

      default: // Premium / Advanced
        bgColor = const Color(0xFFE3F2FD); // Light Blue
        borderColor = const Color(0xFF1565C0);
        textColor = const Color(0xFF0D47A1);
        chipColor = const Color(0xFF90CAF9);
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = p;
        });
        if (flowType == FlowType.job) {
          controller.planId = p.id.toString();
        } else {
          offerController.planId = p.id.toString();
        }

        next(p.duration);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * .44,
        height: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,

          // Use image instead of color if you want
          image: const DecorationImage(
            image: AssetImage("assets/images/plan_bg.png"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),

          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    p.title.toUpperCase(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              p.duration,
              style: TextStyle(
                color: textColor,
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "₹${p.price}/-",
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutSelection() {
    final data = flowType == FlowType.job
        ? {
            'business_name': controller.businessName,
            'job_role': controller.jobRole,
            'salary': controller.salary.toString(),
            'job_type': controller.jobType,
          }
        : {
            'business_name': offerController.businessName,
            'offer_details': offerController.offerDetails,
            'subcategory': offerController.subCategory,
          };

    final templates = flowType == FlowType.job
        ? [
            {'id': 'T001', 'widget': JobTemplatesSmall.templateT001(data)},
            {'id': 'T002', 'widget': JobTemplatesSmall.templateT002(data)},
            {'id': 'T003', 'widget': JobTemplatesSmall.templateT003(data)},
            {'id': 'T004', 'widget': JobTemplatesSmall.templateT004(data)},
          ]
        : [
            {'id': 'T001', 'widget': OfferTemplates.templateT001(data)},
            {'id': 'T002', 'widget': OfferTemplates.templateT002(data)},
            {'id': 'T003', 'widget': OfferTemplates.templateT003(data)},
            {'id': 'T004', 'widget': OfferTemplates.templateT004(data)},
          ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🖼️ Your poster layouts!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: templates.length,
            itemBuilder: (context, i) {
              final t = templates[i];
              return GestureDetector(
                onTap: () {
                  if (flowType == FlowType.job) {
                    controller.tempId = t['id'] as String;
                  } else {
                    offerController.tempId = t['id'] as String;
                  }
                  next("Layout ${i + 1}");
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: AbsorbPointer(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 300,
                        height: 400,
                        child: t['widget'] as Widget,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _finalConfirmation() {
    final data = flowType == FlowType.job
        ? {
            'business_name': controller.businessName,
            'job_role': controller.jobRole,
            'salary': controller.salary.toString(),
            'job_type': controller.jobType,
          }
        : {
            'business_name': offerController.businessName,
            'offer_details': offerController.offerDetails,
            'subcategory': offerController.subCategory,
          };

    Widget preview;
    if (flowType == FlowType.job) {
      switch (controller.tempId) {
        case 'T001':
          preview = JobTemplatesSmall.templateT001(data);
          break;
        case 'T002':
          preview = JobTemplatesSmall.templateT002(data);
          break;
        case 'T003':
          preview = JobTemplatesSmall.templateT003(data);
          break;
        case 'T004':
          preview = JobTemplatesSmall.templateT004(data);
          break;
        default:
          preview = const Center(
              child: Icon(Icons.insert_photo_outlined, size: 50, color: Colors.grey));
      }
    } else {
      switch (offerController.tempId) {
        case 'T001':
          preview = OfferTemplates.templateT001(data);
          break;
        case 'T002':
          preview = OfferTemplates.templateT002(data);
          break;
        case 'T003':
          preview = OfferTemplates.templateT003(data);
          break;
        case 'T004':
          preview = OfferTemplates.templateT004(data);
          break;
        default:
          preview = const Center(
              child: Icon(Icons.insert_photo_outlined, size: 50, color: Colors.grey));
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            height: 350,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 300,
                height: 400,
                child: preview,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (flowType == FlowType.job)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text("Edit Poster"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPosterScreen(
                        shopName: controller.businessName,
                        jobRole: controller.jobRole,
                        jobType: controller.jobType,
                        salary: controller.salary.toString(),
                        phone: controller.phone,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      controller.businessName = result["shopName"];
                      controller.jobRole = result["jobRole"];
                      controller.jobType = result["jobType"];
                      controller.salary =
                          int.tryParse(result["salary"].toString()) ?? controller.salary;
                      controller.phone = result["phone"];
                    });
                  }
                },
              ),
            ),
          if (flowType == FlowType.offer)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text("Edit Poster"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditOfferPosterScreen(
                        shopName: offerController.businessName,
                        offerDetails: offerController.offerDetails,
                        phone: offerController.mobile,
                        images: offerController.images,
                        video: offerController.video,
                      ),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      offerController.businessName = result["shopName"];
                      offerController.offerDetails = result["offerDetails"];
                      offerController.mobile = result["phone"];
                      offerController.images = result["images"];
                      offerController.video = result["video"];
                    });
                  }
                },
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.payment),
              label: const Text("Proceed for payment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                if (selectedPlan == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a plan first")),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtpVerificationScreen(
                      mobileNumber: flowType == FlowType.job ? controller.phone : offerController.mobile,
                      plan: selectedPlan!,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5EA))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: input,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onSubmitted: next,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => next(input.text.trim()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
