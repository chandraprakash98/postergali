import 'package:flutter/material.dart';
import 'package:postergali/features/posterman/plan.dart';

class PlanSelectionScreen extends StatefulWidget {
  const PlanSelectionScreen({super.key});

  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  bool loading = true;
  List<PlanModel> plans = [];

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    try {
      // Call your API here

      // Example:
      // final controller = PosterManController(...);
      // await controller.loadPlans();
      // plans = controller.plans;

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Plan"),
      ),
      body: loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(plan.title),
              subtitle: Text(plan.duration),
              trailing: Text("₹${plan.price}"),
              onTap: () {
                Navigator.pop(context, plan);
              },
            ),
          );
        },
      ),
    );
  }
}