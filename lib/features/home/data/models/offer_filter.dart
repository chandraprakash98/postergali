class OfferFilterModel {
  final List<String> categories;
  final String? expiry;

  OfferFilterModel({
    this.categories = const [],
    this.expiry,
  });

  Map<String, String> toQuery({
    required double latitude,
    required double longitude,
  }) {
    return {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "sub_categories": categories.map((e) => e.toLowerCase()).join(','),
      "is_expiry": (expiry ?? '').toLowerCase().replaceAll(' ', '_'),
    };
  }

  OfferFilterModel copyWith({
    List<String>? categories,
    String? expiry,
  }) {
    return OfferFilterModel(
      categories: categories ?? this.categories,
      expiry: expiry ?? this.expiry,
    );
  }
}
