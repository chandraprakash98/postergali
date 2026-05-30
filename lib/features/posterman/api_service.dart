import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:postergali/features/posterman/plan.dart';

import '../../core/job_request.dart';
import 'offer/offer_request.dart';

class ApiService {
  static const String baseUrl = "https://postergali.com/api/v1";

  Future<bool> submitJob(JobRequest request) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/jobs"),
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
    try {
      final res = await http.get(Uri.parse("$baseUrl/plans"));

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => PlanModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }


  Future<bool> submitOffer({
    required OfferRequest request,
    required List<File> images,
    File? video,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/offers");

      var req = http.MultipartRequest("POST", uri);

      req.fields["device_id"] = request.deviceId;
      req.fields["device_os"] = request.deviceOs;
      req.fields["master_category"] = request.masterCategory;
      req.fields["subcategory"] = request.subcategory;
      req.fields["business_name"] = request.businessName;
      req.fields["offer_details"] = request.offerDetails;
      req.fields["offer_type"] = request.offerType;
      req.fields["mobile_number"] = request.mobileNumber;
      req.fields["latitude"] = request.latitude.toString();
      req.fields["longitude"] = request.longitude.toString();
      req.fields["city"] = request.city;
      req.fields["plan_id"] = request.planId;
      req.fields["temp_id"] = request.templateId;

      for (File image in images) {
        req.files.add(
          await http.MultipartFile.fromPath(
            "images[]",
            image.path,
          ),
        );
      }

      if (video != null) {
        req.files.add(
          await http.MultipartFile.fromPath(
            "video",
            video.path,
          ),
        );
      }

      final response = await req.send();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}