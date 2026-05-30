import 'package:flutter/material.dart';

class EditPosterScreen extends StatefulWidget {
  final String shopName;
  final String jobRole;
  final String jobType;
  final String salary;
  final String phone;

  const EditPosterScreen({
    super.key,
    required this.shopName,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.phone,
  });

  @override
  State<EditPosterScreen> createState() => _EditPosterScreenState();
}

class _EditPosterScreenState extends State<EditPosterScreen> {
  late TextEditingController shopController;
  late TextEditingController roleController;
  late TextEditingController typeController;
  late TextEditingController salaryController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    shopController = TextEditingController(text: widget.shopName);
    roleController = TextEditingController(text: widget.jobRole);
    typeController = TextEditingController(text: widget.jobType);
    salaryController = TextEditingController(text: widget.salary);
    phoneController = TextEditingController(text: widget.phone);
  }

  Widget buildField(String title, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
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
      appBar: AppBar(
        title: const Text("Edit Poster"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildField("Shop Name", shopController),
                    buildField("Job Role", roleController),
                    buildField("Job Type", typeController),
                    buildField("Salary", salaryController),
                    buildField("Phone Number", phoneController),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "shopName": shopController.text,
                    "jobRole": roleController.text,
                    "jobType": typeController.text,
                    "salary": salaryController.text,
                    "phone": phoneController.text,
                  });
                },
                child: const Text("Confirm"),
              ),
            )
          ],
        ),
      ),
    );
  }
}