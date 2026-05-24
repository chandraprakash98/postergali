class JobFilterModel {
  final List<String> categories;
  final String? expiry;
  final String? jobType;
  final String? salary;

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

  JobFilterModel copyWith({
    List<String>? categories,
    String? expiry,
    String? jobType,
    String? salary,
  }) {
    return JobFilterModel(
      categories: categories ?? this.categories,
      expiry: expiry ?? this.expiry,
      jobType: jobType ?? this.jobType,
      salary: salary ?? this.salary,
    );
  }
}
