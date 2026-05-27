class JobRequest {
  final String deviceId;
  final String deviceOs;
  final String masterCategory;
  final String subcategory;
  final String businessName;
  final String jobRole;
  final String jobType;
  final int salary;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String city;
  final String planId;
  final String tempId;

  JobRequest({
    required this.deviceId,
    required this.deviceOs,
    required this.masterCategory,
    required this.subcategory,
    required this.businessName,
    required this.jobRole,
    required this.jobType,
    required this.salary,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.planId,
    required this.tempId,
  });


  Map<String, dynamic> toJson() {
    return {
      "device_id": deviceId,
      "device_os": deviceOs,
      "master_category": masterCategory,
      "subcategory": subcategory,
      "business_name": businessName,
      "job_role": jobRole,
      "job_type": jobType,
      "salary": salary,
      "phone_number": phoneNumber,
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "plan_id": planId,
      "temp_id": tempId,
    };
  }
}