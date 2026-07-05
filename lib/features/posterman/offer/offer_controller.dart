import 'dart:io';

import '../api_service.dart';
import '../location_service.dart';
import '../plan.dart';
import 'offer_request.dart';

class OfferController {
  final LocationService locationService;
  final ApiService apiService;

  OfferController({
    required this.locationService,
    required this.apiService,
  });

  String businessName = "";
  String offerDetails = "";
  String offerType = "";
  String subCategory = "";
  String mobile = "";
  String planId = "";
  String tempId = "";

  double lat = 0;
  double lng = 0;
  String city = "";

  List<File> images = [];
  File? video;

  List<PlanModel> plans = [];

  Future<void> loadPlans() async {
    plans = await apiService.fetchPlans();
  }

  OfferRequest buildRequest() {
    return OfferRequest(
      deviceId: "12345",
      deviceOs: "android",
      masterCategory: "offers",
      subcategory: subCategory,
      businessName: businessName,
      offerDetails: offerDetails,
      offerType: offerType,
      mobileNumber: mobile,
      latitude: lat,
      longitude: lng,
      city: city,
      planId: planId,
      templateId: tempId,
    );
  }
}