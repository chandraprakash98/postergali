

import '../../core/job_request.dart';
import 'api_service.dart';
import 'location_service.dart';

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

  double lat = 0;
  double lng = 0;
  String city = "";

  Future<void> fetchLocation() async {
    final data = await locationService.getCurrentLocation();

    lat = data["lat"];
    lng = data["lng"];
    city = data["city"];
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
      salary: 50000,
      phoneNumber: phone,
      latitude: lat,
      longitude: lng,
      city: city,
      planId: "P001",
      tempId: "T003",
    );
  }
}