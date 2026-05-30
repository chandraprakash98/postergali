class OfferRequest {
  final String deviceId;
  final String deviceOs;
  final String masterCategory;
  final String subcategory;
  final String businessName;
  final String offerDetails;
  final String offerType;
  final String mobileNumber;
  final double latitude;
  final double longitude;
  final String city;
  final String planId;
  final String templateId;

  OfferRequest({
    required this.deviceId,
    required this.deviceOs,
    required this.masterCategory,
    required this.subcategory,
    required this.businessName,
    required this.offerDetails,
    required this.offerType,
    required this.mobileNumber,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.planId,
    required this.templateId,
  });
}
