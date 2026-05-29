import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReferFriendFormScreen extends StatefulWidget {
  const ReferFriendFormScreen({super.key});

  @override
  State<ReferFriendFormScreen> createState() => _ReferFriendFormScreenState();
}

class _ReferFriendFormScreenState extends State<ReferFriendFormScreen> {
  final TextEditingController yourName = TextEditingController();
  final TextEditingController yourPhone = TextEditingController();

  List<Map<String, TextEditingController>> friends = [];

  void addFriend() {
    setState(() {
      friends.add({
        "name": TextEditingController(),
        "phone": TextEditingController(),
      });
    });
  }

  void removeFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F1E7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= TOP BAR =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        CupertinoIcons.back,
                        size: 28,
                        color: Color(0xffB33D22),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      "Refer a friend",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff4B1E16),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= YOUR DETAILS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _card(
                  title: "Enter your details",
                  child: Column(
                    children: [
                      _field("Your name", yourName),
                      const SizedBox(height: 20),
                      _field("Your phone number", yourPhone),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= FRIEND DETAILS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _card(
                  title: "Enter your friend’s details",
                  child: Column(
                    children: [
                      // ADD BUTTON
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: addFriend,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Friend"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffB33D22),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // FRIEND LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Friend ${index + 1}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () => removeFriend(index),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(height: 10),

                                _field(
                                  "Friend name",
                                  friends[index]["name"]!,
                                ),

                                const SizedBox(height: 12),

                                _field(
                                  "Friend phone number",
                                  friends[index]["phone"]!,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= SUBMIT BUTTON =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xffB33D22),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Submit Referral",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xffFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE0A15A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff4B1E16),
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  // ================= TEXT FIELD =================
  Widget _field(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}