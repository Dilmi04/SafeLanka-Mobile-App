class GuideModel {
  final String title;
  final String heading;
  final String imageUrl;
  final List<String> safetySteps;

  GuideModel({
    required this.title,
    required this.heading,
    required this.imageUrl,
    required this.safetySteps,
  });


  factory GuideModel.fromJson(Map<String, dynamic> json) {
    return GuideModel(
      title: json['title'],
      heading: json['heading'],
      imageUrl: json['imageUrl'],
      safetySteps: List<String>.from(json['safetySteps']),
    );
  }
}