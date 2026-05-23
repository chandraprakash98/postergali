/// =======================================================
/// FILTER MODEL
/// =======================================================

class JobFilterModel {
  List<String> categories;
  String? expiry;
  String? jobType;
  String? salary;

  JobFilterModel({
    this.categories = const [],
    this.expiry,
    this.jobType,
    this.salary,
  });

  Map<String, String> toQuery({
    required double latitude,
    required double longitude,
  }) {
    return {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "categories": categories.join(','),
      "expiry": expiry ?? '',
      "job_type": jobType ?? '',
      "salary": salary ?? '',
    };
  }
}