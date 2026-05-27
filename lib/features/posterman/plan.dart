class PlanModel {
  final int id;
  final String title;
  final String duration;
  final String price;

  PlanModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      title: json['plan_title'],
      duration: json['duration'],
      price: json['price'].toString(),
    );
  }
}