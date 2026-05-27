

import '../../core/job_request.dart';
import 'api_service.dart';
import 'location_service.dart';
import 'plan.dart';

class PosterManController {
  final LocationService locationService;
  final ApiService apiService;

  PosterManController({
    required this.locationService,
    required this.apiService,
  });

  String businessName = "";
  String jobRole = "";
  String jobType = "";
  String phone = "";
  int salary = 0;
  String planId = "";
  String tempId = "";

  double lat = 0;
  double lng = 0;
  String city = "";

  List<PlanModel> plans = [];

  Future<void> fetchLocation() async {
    final data = await locationService.getCurrentLocation();

    lat = data["lat"];
    lng = data["lng"];
    city = data["city"];
  }

  Future<void> loadPlans() async {
    plans = await apiService.fetchPlans();
  }

  JobRequest buildRequest() {
    return JobRequest(
      deviceId: "AUTO_DEVICE_ID",
      deviceOs: "android",
      masterCategory: "jobs",
      subcategory: "IT",
      businessName: businessName,
      jobRole: jobRole,
      jobType: jobType,
      salary: salary,
      phoneNumber: phone,
      latitude: lat,
      longitude: lng,
      city: city,
      planId: planId,
      tempId: tempId,
    );
  }
}