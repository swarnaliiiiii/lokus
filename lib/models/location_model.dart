class LocationModel {
  final String id;
  final String name;
  final String country;
  final String fullName;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.id,
    required this.name,
    required this.country,
    required this.fullName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['place_id'] ?? '',
      name: json['structured_formatting']?['main_text'] ?? json['description'] ?? '',
      country: json['structured_formatting']?['secondary_text'] ?? '',
      fullName: json['description'] ?? '',
      latitude: 0.0, // Will be populated when needed
      longitude: 0.0, // Will be populated when needed
    );
  }

  @override
  String toString() => fullName;
}