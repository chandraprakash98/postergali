import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:postergali/core/job_request.dart';
import 'package:postergali/features/posterman/posterman_controller.dart';
import 'api_service.dart';
import 'location_service.dart';

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
  phone,
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

    // ✅ USE HOME LOCATION ONLY (NO FETCH HERE)
    selectedLatLng = LatLng(widget.latitude, widget.longitude);
    controller.lat = widget.latitude;
    controller.lng = widget.longitude;
    controller.city = widget.location;

    _startFlow();
  }

  // ---------------- BOT ----------------

  Future<void> bot(String text) async {
    setState(() => isBotTyping = true);
    await Future.delayed(const Duration(milliseconds: 300));

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
  }

  // ---------------- FLOW ----------------

  Future<void> _startFlow() async {
    await bot(
        "Welcome to PosterGali!\n"
            "Create and publish posters easily 🚀"
    );

    setState(() => step = ChatStep.chooseType);

    await bot("Please choose poster type:");
    addTypeChips();
  }

  void addTypeChips() {
    messages.add({"bot": true, "type": "type_chips"});
    setState(() {});
  }

  void addJobTypeChips() {
    messages.add({"bot": true, "type": "job_type_chips"});
    setState(() {});
  }

  void addLocationMap() {
    messages.add({"bot": true, "type": "location_map"});
    setState(() {});
  }

  // ---------------- NEXT ----------------

  void next(String text) async {
    if (text.isEmpty) return;

    user(text);

    switch (step) {
      case ChatStep.chooseType:
        if (text.toLowerCase() == "jobs") {
          step = ChatStep.businessName;
          await bot("What is your business name?");
        }
        break;

      case ChatStep.businessName:
        controller.businessName = text;

        await bot(
            "📍 Your location:\n\n"
                "${widget.location}\n\n"
                "Is this correct?"
        );

        addLocationMap();
        setState(() => step = ChatStep.locationConfirm);
        break;

      case ChatStep.locationConfirm:
        await bot("Great 👍 Now enter job role");
        setState(() => step = ChatStep.jobRole);
        break;

      case ChatStep.jobRole:
        controller.jobRole = text;

        await bot("Select job type:");
        addJobTypeChips();

        setState(() => step = ChatStep.jobTypeSelect);
        break;

      case ChatStep.jobTypeSelect:
        controller.jobType = text;

        await bot("Enter phone number");
        setState(() => step = ChatStep.phone);
        break;

      case ChatStep.phone:
        controller.phone = text;

        await bot("Submitting...");

        final success = await controller.apiService.submitJob(
          controller.buildRequest() as JobRequest,
        );

        await bot(success ? "🎉 Posted successfully!" : "❌ Failed");

        setState(() => step = ChatStep.done);
        break;

      default:
        break;
    }

    input.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (scroll.hasClients) {
        scroll.animateTo(
          scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Poster Man")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: messages.length + (isBotTyping ? 1 : 0),
              itemBuilder: (context, i) {
                if (isBotTyping && i == messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Typing..."),
                    ),
                  );
                }

                final m = messages[i];

                if (m["type"] == "type_chips") return _typeChips();
                if (m["type"] == "job_type_chips") return _jobTypeChips();
                if (m["type"] == "location_map") return _locationMapCard();

                return _bubble(m);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: input)),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => next(input.text.trim()),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------- MAP ----------------

  Widget _locationMapCard() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📍 Current Location",
            style: TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 10),

          Container(
            height: 200,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
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
              myLocationEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {
              user("Location selected 👍");
              await bot(
                  "Now tell us job role (e.g. Helper, Cook, Delivery Boy)"
              );
              setState(() => step = ChatStep.jobRole);
            },
            child: const Text("Use Current Location"),
          )
        ],
      ),
    );
  }

  // ---------------- CHIPS ----------------

  Widget _typeChips() {
    return Wrap(
      children: [
        ActionChip(
          label: const Text("Jobs"),
          onPressed: () => next("jobs"),
        ),
      ],
    );
  }

  Widget _jobTypeChips() {
    return Wrap(
      children: [
        ActionChip(
          label: const Text("Full-time"),
          onPressed: () => next("full-time"),
        ),
        const SizedBox(width: 10),
        ActionChip(
          label: const Text("Part-time"),
          onPressed: () => next("part-time"),
        ),
      ],
    );
  }

  // ---------------- BUBBLE ----------------

  Widget _bubble(Map m) {
    return Align(
      alignment: m["bot"] ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: m["bot"] ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(m["text"] ?? ""),
      ),
    );
  }
}