import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postergali/core/job_request.dart';
import 'package:postergali/core/widgets/job_templates_small.dart';
import 'package:postergali/features/posterman/posterman_controller.dart';
import 'api_service.dart';
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
  jobRole,
  jobTypeSelect,
  salary,
  phone,
  planSelect,
  layoutSelect,
  done
}

class _PosterManChatScreenState extends State<PosterManChatScreen> {
  late PosterManController controller;

  final TextEditingController input = TextEditingController();
  final ScrollController scroll = ScrollController();

  ChatStep step = ChatStep.welcome;

  List<Map<String, dynamic>> messages = [];
  bool isBotTyping = false;

  LatLng? selectedLatLng;

  @override
  void initState() {
    super.initState();

    controller = PosterManController(
      locationService: LocationService(),
      apiService: ApiService(),
    );

    selectedLatLng = LatLng(widget.latitude, widget.longitude);
    controller.lat = widget.latitude;
    controller.lng = widget.longitude;
    controller.city = widget.location;

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

    switch (step) {
      case ChatStep.chooseType:
        if (text.toLowerCase().contains("hiring")) {
          step = ChatStep.businessName;
          await bot("What is your business name &\naddress where you want job?");
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
        // planId is set in _planCard onTap
        await bot("📍 Your poster layouts!");
        await bot("All you have to do is select any one layout below and we'll create a poster for you style ✨");
        addLayoutSelection();
        setState(() => step = ChatStep.layoutSelect);
        break;

      case ChatStep.layoutSelect:
        // controller.tempId is already set in _layoutSelection onTap
        await bot("Ready to display the poster?");
        await bot("👉 Tap the button below to post");
        addFinalConfirmation();
        setState(() => step = ChatStep.done);
        break;

      case ChatStep.done:
        break;

      default:
        break;
    }

    input.clear();
    scrollToBottom();
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
          color: isBot ? Colors.white : const Color(0xFF9EA0A7),
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
            color: isBot ? Colors.black : Colors.white,
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
          _chip("Hire Others", () => next("Hire Others")),
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
      backgroundColor: Colors.white,
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
        color: Colors.white,
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            widget.location,
            style: const TextStyle(color: Colors.grey),
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
                backgroundColor: const Color(0xFF9EA0A7),
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
                foregroundColor: Colors.black,
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: controller.plans.map((p) => _planCard(p)).toList(),
      ),
    );
  }

  Widget _planCard(PlanModel p) {
    return GestureDetector(
      onTap: () {
        controller.planId = p.id.toString();
        next(p.duration);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                p.title.toUpperCase(),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              p.duration,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${p.price}/-",
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutSelection() {
    final jobData = {
      'business_name': controller.businessName,
      'job_role': controller.jobRole,
      'salary': controller.salary.toString(),
      'job_type': controller.jobType,
    };

    final templates = [
      {'id': 'T001', 'widget': JobTemplatesSmall.templateT001(jobData)},
      {'id': 'T002', 'widget': JobTemplatesSmall.templateT002(jobData)},
      {'id': 'T003', 'widget': JobTemplatesSmall.templateT003(jobData)},
      {'id': 'T004', 'widget': JobTemplatesSmall.templateT004(jobData)},
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
                  controller.tempId = t['id'] as String;
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
    final jobData = {
      'business_name': controller.businessName,
      'job_role': controller.jobRole,
      'salary': controller.salary.toString(),
      'job_type': controller.jobType,
    };

    Widget preview;
    switch (controller.tempId) {
      case 'T001':
        preview = JobTemplatesSmall.templateT001(jobData);
        break;
      case 'T002':
        preview = JobTemplatesSmall.templateT002(jobData);
        break;
      case 'T003':
        preview = JobTemplatesSmall.templateT003(jobData);
        break;
      case 'T004':
        preview = JobTemplatesSmall.templateT004(jobData);
        break;
      default:
        preview = const Center(child: Icon(Icons.insert_photo_outlined, size: 50, color: Colors.grey));
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.edit_note),
              label: const Text("Edit Poster"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9EA0A7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
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
              onPressed: () async {
                final success = await controller.apiService.submitJob(
                  controller.buildRequest() as JobRequest,
                );
                await bot(success ? "🎉 Posted successfully!" : "❌ Failed to post");
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
              decoration: const BoxDecoration(
                color: Color(0xFF9EA0A7),
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
