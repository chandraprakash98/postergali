import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditOfferPosterScreen extends StatefulWidget {
  final String shopName;
  final String offerDetails;
  final String phone;
  final List<File> images;
  final File? video;

  const EditOfferPosterScreen({
    super.key,
    required this.shopName,
    required this.offerDetails,
    required this.phone,
    required this.images,
    this.video,
  });

  @override
  State<EditOfferPosterScreen> createState() => _EditOfferPosterScreenState();
}

class _EditOfferPosterScreenState extends State<EditOfferPosterScreen> {
  late TextEditingController shopController;
  late TextEditingController offerController;
  late TextEditingController phoneController;
  late List<File> images;
  File? video;

  @override
  void initState() {
    super.initState();
    shopController = TextEditingController(text: widget.shopName);
    offerController = TextEditingController(text: widget.offerDetails);
    phoneController = TextEditingController(text: widget.phone);
    images = List.from(widget.images);
    video = widget.video;
  }

  Widget buildField(String title, TextEditingController controller, {String hint = "Select Number of days"}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Poster",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildField("Shop Name", shopController),
                    buildField("Offer", offerController),
                    
                    // Media Section
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Media",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _pickMedia,
                            child: Container(
                              width: double.infinity,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  style: BorderStyle.solid, // Note: dashed line would need custom painter
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.upload, size: 20),
                                        SizedBox(width: 8),
                                        Text("Upload", style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Maximum 500 MB file size",
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // List of media
                          ...images.map((img) => _mediaItem(
                            icon: Icons.image_outlined,
                            onDelete: () => setState(() => images.remove(img)),
                          )),
                          if (video != null)
                            _mediaItem(
                              icon: Icons.video_library_outlined,
                              onDelete: () => setState(() => video = null),
                            ),
                        ],
                      ),
                    ),

                    buildField("Phone Number", phoneController),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "shopName": shopController.text,
                    "offerDetails": offerController.text,
                    "phone": phoneController.text,
                    "images": images,
                    "video": video,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAAAAAA),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _mediaItem({required IconData icon, required VoidCallback onDelete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const Spacer(),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () async {
                Navigator.pop(context);
                final List<XFile> pickedFiles = await picker.pickMultiImage();
                if (pickedFiles.isNotEmpty) {
                  setState(() {
                    images.addAll(pickedFiles.map((x) => File(x.path)));
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Video Library'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    video = File(pickedFile.path);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
