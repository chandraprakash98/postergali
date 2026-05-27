import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postergali/features/posterman/plan.dart';

import '../../core/job_request.dart';

class ApiService {

  static const String baseUrl =
      "https://postergali.com/api/v1/jobs";

  Future<bool> submitJob(JobRequest request) async {

    try {
      final res = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(request.toJson()),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<PlanModel>> fetchPlans() async {
    final res = await http.get(Uri.parse("$baseUrl/plans"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PlanModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load plans");
    }
  }

}